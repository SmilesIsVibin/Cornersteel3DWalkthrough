extends CollisionObject3D
class_name Interactable

signal interacted(body)

func interact(body): # Base class for interaction
	interacted.emit(body)
