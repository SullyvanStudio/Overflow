extends Resource
class_name ActionSoin_base

@export var nom : String
@export var ressource_requise : Ressource_base
@export var duree_tours : int = 1
@export var delai_resultat_tours : int = 0   # 0 = résultat dispo à la fin de l'action ; sinon délai en plus (ex: labo). Champ prêt, pas encore câblé dans ActionInstance — à faire quand on attaquera le Labo.
@export var action_suivante_auto : ActionSoin_base  # ex: ECG -> Interprétation ECG
@export var necessite_pause : bool = false   # true = pause le jeu pendant l'exécution
@export var est_prescriptible : bool = true  # false = créée uniquement via chaînage (ex: interprétations)
