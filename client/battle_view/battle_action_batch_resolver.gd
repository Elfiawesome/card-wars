class_name BattleActionBatchResolver extends Node
# I DON'T KNOW WHAT IS GOING ON HERE 😭😭😭😭😭😭😭


signal completed()           # Emitted when the resolver finishes according to its mode
signal process_action(action: Dictionary) # Emitted for each ACTION item

var list: Array = []        # The list of actions/batches to process
var batch_mode: BattleActions.BATCH_MODE = BattleActions.BATCH_MODE.BLOCK # Mode for this resolver

var _animation_clip: AnimationClip = null # The animation clip controlling timing
var _is_active: bool = false         # Is the resolver currently processing?
var _processing_index: int = -1      # Current index being processed (-1 means not started)

# State for BLOCK mode
var _block_waiting_for_sub: bool = false
var _block_current_sub_resolver: BattleActionBatchResolver = null

# State for JOINED mode
var _joined_active_children: Dictionary = {} # Dictionary[Node, bool] (Node can be Resolver or other Action handler)
var _joined_initial_dispatch_complete: bool = false

# --- Animation Clip Setter ---
func set_animation_clip(value: AnimationClip) -> void:
	if _animation_clip == value: return
	if is_instance_valid(_animation_clip):
		# Disconnect signals if connected
		if _animation_clip.keyframe_triggered.is_connected(_on_animation_keyframe):
			_animation_clip.keyframe_triggered.disconnect(_on_animation_keyframe)
		if _animation_clip.end_triggered.is_connected(_on_animation_end):
			_animation_clip.end_triggered.disconnect(_on_animation_end)
		if _animation_clip.get_parent() == self:
			remove_child(_animation_clip)
		_animation_clip.queue_free()

	_animation_clip = value
	if is_instance_valid(_animation_clip):
		# Ensure it doesn't auto-process if added before start() is called
		_animation_clip.set_process(false)
		add_child(_animation_clip)
		# Connections are made in start()

# --- Public Methods ---

func start() -> void:
	if _is_active: push_warning("Resolver '%s' already started." % name); return
	if list.is_empty(): _complete(); return

	_is_active = true
	_processing_index = -1 # Reset index
	_block_waiting_for_sub = false
	_block_current_sub_resolver = null
	_joined_active_children.clear()
	_joined_initial_dispatch_complete = false


	if is_instance_valid(_animation_clip):
		# Animation drives the processing via keyframes
		if !_animation_clip.keyframe_triggered.is_connected(_on_animation_keyframe):
			_animation_clip.keyframe_triggered.connect(_on_animation_keyframe)
		if !_animation_clip.end_triggered.is_connected(_on_animation_end):
			_animation_clip.end_triggered.connect(_on_animation_end)
		_animation_clip.set_process(true) # Allow animation processing
		_animation_clip.start()
		# The first keyframe trigger will call _on_animation_keyframe -> process_next_item
	else:
		# No animation, process based on mode "instantly"
		_process_remaining_items_instantly()


func stop() -> void:
	if not _is_active: return
	_is_active = false

	if is_instance_valid(_animation_clip):
		set_animation_clip(null) # Use setter for cleanup

	# Clean up any tracked children
	if is_instance_valid(_block_current_sub_resolver):
		if _block_current_sub_resolver.get_parent() == self:
			_block_current_sub_resolver.stop() # Stop child first
			_block_current_sub_resolver.queue_free()
		_block_current_sub_resolver = null

	for child_resolver: BattleActionBatchResolver in _joined_active_children.keys():
		if is_instance_valid(child_resolver) and child_resolver is BattleActionBatchResolver:
			if child_resolver.get_parent() == self:
				child_resolver.stop()
				child_resolver.queue_free()

	_joined_active_children.clear()
	# list.clear() # Optional: Decide if stopping should clear the list

# --- Internal Processing Logic ---

# Processes the *next* item in the list. Called by animation or internal loops.
func process_next_item() -> void:
	if not _is_active: return
	if batch_mode == BattleActions.BATCH_MODE.BLOCK and _block_waiting_for_sub: return # Blocked

	_processing_index += 1
	if _processing_index >= list.size():
		# Reached end of list for this processing step/loop
		_check_completion_after_iteration()
		return

	var current_item: Dictionary = list[_processing_index]
	_handle_item(current_item)

# Handles a single item based on its type (Action or Batch)
func _handle_item(item: Dictionary) -> void:
	var block_type := BattleActions.get_item_block_type(item)
	
	match block_type:
		BattleActions.BLOCK_TYPE.ACTION:
			var _action_type := BattleActions.get_action_type(item)
			process_action.emit(item)
			# For JOINED mode, action completion is instant, so track it immediately
			if batch_mode == BattleActions.BATCH_MODE.JOINED:
				# We don't track individual actions in the _joined_active_children
				# because they complete instantly within this frame.
				# If actions could be async, we'd need to track them.
				pass # Assume instant completion for actions
		
		BattleActions.BLOCK_TYPE.BATCH:
			var sub_batch_list := BattleActions.get_batch_list(item)
			var sub_batch_mode := BattleActions.get_batch_mode(item)
			var sub_batch_anim_data := BattleActions.get_batch_animation(item)
			
			if sub_batch_list.is_empty():
				push_warning("Resolver '%s': Encountered an empty sub-batch." % name)
				# Treat empty batch completion based on parent mode
				if batch_mode == BattleActions.BATCH_MODE.JOINED:
					pass # Empty batch completes instantly, doesn't need tracking
				return # Move to next item
			
			# Create and configure the sub-resolver
			var sub_resolver := BattleActionBatchResolver.new()
			sub_resolver.name = "%s_Sub_%d" % [name, get_child_count()]
			sub_resolver.list = sub_batch_list.duplicate()
			sub_resolver.batch_mode = sub_batch_mode
			
			# Assign animation clip to the sub-resolver if specified
			if sub_batch_anim_data:
				var sub_anim_type := BattleActions.get_animation_type(sub_batch_anim_data)
				var sub_anim_args := BattleActions.get_animation_args(sub_batch_anim_data)
				var sub_anim_clip := AnimationClip.get_animation_clip(sub_anim_type, sub_anim_args)
				if is_instance_valid(sub_anim_clip):
					sub_resolver.set_animation_clip(sub_anim_clip) # Setter adds as child
			
			# Connect completion signal - ALWAYS connect for cleanup, handle based on mode
			# Use CONNECT_DEFERRED if issues arise with immediate execution/deletion
			sub_resolver.completed.connect(_on_sub_resolver_completed.bind(sub_resolver), CONNECT_ONE_SHOT)
			
			# Connect process_action passthrough (optional)
			sub_resolver.process_action.connect(func(action: Dictionary) -> void: process_action.emit(action))
			
			add_child(sub_resolver)
			sub_resolver.start() # Start the sub-resolver
			
			# --- Handle based on PARENT'S mode ---
			match batch_mode:
				BattleActions.BATCH_MODE.BLOCK:
					if is_instance_valid(sub_resolver) and sub_resolver._is_active:
						_block_waiting_for_sub = true
						_block_current_sub_resolver = sub_resolver
						if is_instance_valid(_animation_clip):
							_animation_clip.pause()
					else:
						pass
				
				BattleActions.BATCH_MODE.JOINED:
					# Track the sub-resolver; continue processing next item in *this* resolver
					_joined_active_children[sub_resolver] = true
				
				BattleActions.BATCH_MODE.NONE:
					# No tracking needed for completion signal, just launched it.
					# The 'completed' connection is mainly for cleanup now.
					pass
		
		_: # Handle NONE block type or unknown
			push_warning("Resolver '%s': Skipping unknown item type: %s" % [name, item])


# Processes all items from the current index onwards without animation delays
func _process_remaining_items_instantly() -> void:
	if not _is_active: return
	
	# Prevent re-entry if called while already looping
	if get_meta("processing_instantly", false): return
	set_meta("processing_instantly", true)
	
	while _is_active and _processing_index < list.size() - 1:
		if batch_mode == BattleActions.BATCH_MODE.BLOCK and _block_waiting_for_sub:
			# If we hit a blocking sub-resolver during instant processing, stop the loop
			break
		process_next_item()
	
	set_meta("processing_instantly", false) # Allow re-entry later if needed
	
	# After the loop (or break), check if we might be complete
	_check_completion_after_iteration()


# Checks if the resolver should complete after finishing an iteration or animation end
func _check_completion_after_iteration() -> void:
	if not _is_active: return
	
	# Mark that the initial dispatch/processing of the list is done
	if _processing_index >= list.size() - 1:
		_joined_initial_dispatch_complete = true # Relevant for JOINED mode
	
	# Completion condition depends on the mode
	var can_complete_based_on_list_and_mode := false
	match batch_mode:
		BattleActions.BATCH_MODE.BLOCK:
			# Complete if list is done AND not waiting for a sub-resolver
			if _processing_index >= list.size() - 1 and not _block_waiting_for_sub:
				can_complete_based_on_list_and_mode = true
		BattleActions.BATCH_MODE.JOINED:
			# Complete if list dispatch is done AND all tracked children are done
			if _joined_initial_dispatch_complete and _joined_active_children.is_empty():
				can_complete_based_on_list_and_mode = true
		BattleActions.BATCH_MODE.NONE:
			# Complete as soon as the list dispatch is done
			if _processing_index >= list.size() - 1:
				can_complete_based_on_list_and_mode = true
	
	# If the list/mode conditions are NOT met, we definitely cannot complete yet.
	if not can_complete_based_on_list_and_mode:
		return
	
	if is_instance_valid(_animation_clip):
		return
	
	_complete()


# --- Signal Handlers ---

func _on_animation_keyframe() -> void:
	if not _is_active: return
	# Process the next item according to the mode
	process_next_item()
	# If JOINED/NONE, animation might trigger multiple items per keyframe,
	# but current design processes one item per keyframe. Adjust if needed.


func _on_animation_end() -> void:
	if not _is_active: return
	set_animation_clip(null) # Clean up animation node

	# Process any remaining items instantly according to mode
	_process_remaining_items_instantly()


func _on_sub_resolver_completed(sub_resolver: BattleActionBatchResolver) -> void:
	# This signal might arrive after the parent has been stopped/completed, so check _is_active
	# Also check if the sub_resolver is still valid
	if not is_instance_valid(sub_resolver):
		return # Sub-resolver was likely freed already
	
	# --- Always perform cleanup ---
	# Remove child + queue_free handled AFTER processing logic to avoid issues
	var should_queue_free := true
	
	# --- Handle based on PARENT'S mode ---
	match batch_mode:
		BattleActions.BATCH_MODE.BLOCK:
			if sub_resolver == _block_current_sub_resolver:
				_block_waiting_for_sub = false
				_block_current_sub_resolver = null
				
				if is_instance_valid(_animation_clip):
					_animation_clip.resume()
				
				# If parent is still active, continue processing its list
				if _is_active:
					if is_instance_valid(_animation_clip):
						# Wait for next animation keyframe
						pass
					else:
						# Process next item(s) instantly
						_process_remaining_items_instantly()
			else:
				# Received signal from unexpected resolver in BLOCK mode (shouldn't happen often)
				push_warning("Resolver '%s' (BLOCK): Received unexpected complete from %s" % [name, sub_resolver.name])
		
		
		BattleActions.BATCH_MODE.JOINED:
			if _joined_active_children.has(sub_resolver):
				_joined_active_children.erase(sub_resolver)
				# Check if this completion allows the parent to complete
				if _is_active:
					_check_completion_after_iteration() # Checks if list done AND children done
			else:
				# Signal from an untracked resolver (might happen if completed very fast or during stop)
				push_warning("Resolver '%s' (JOINED): Received complete from untracked %s" % [name, sub_resolver.name])
		
		BattleActions.BATCH_MODE.NONE:
			# No specific logic needed for parent completion, just cleanup the child.
			pass
	
	# --- Final Cleanup ---
	# Ensure the completed sub-resolver is removed and freed
	if should_queue_free and is_instance_valid(sub_resolver):
		if sub_resolver.get_parent() == self:
			remove_child(sub_resolver) # Remove first to avoid potential parent access issues
		sub_resolver.queue_free()


func _complete() -> void:
	if not _is_active: return # Prevent double completion
	
	var was_active := _is_active
	_is_active = false # Set inactive *before* cleanup
	
	# Final cleanup (in case stop wasn't called or things are lingering)
	if is_instance_valid(_animation_clip): set_animation_clip(null)
	if is_instance_valid(_block_current_sub_resolver):
		if _block_current_sub_resolver.get_parent() == self: _block_current_sub_resolver.queue_free()
		_block_current_sub_resolver = null
	# Clear remaining joined children refs (they should have completed, but be safe)
	# Do not queue_free here as they might be managed elsewhere if completed wasn't received.
	_joined_active_children.clear()
	
	if was_active:
		# clear list
		list.clear()
		completed.emit()
	
	# Optional: Queue free self if the resolver's job is truly done
	# queue_free()


func _exit_tree() -> void:
	# Ensure cleanup if the node is removed from the tree prematurely
	if _is_active:
		stop() # Call stop to handle cleanup correctly
