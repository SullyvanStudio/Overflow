extends Resource
class_name Symptome_base

@export var nom : String
@export var description : String
@export var texture : Texture
@export_enum ("crane","chevillegch","chevilledt","genougch",
"genoudt","hanchegch","hanchedt","pelvis","poignetgch",
"poignetdt","humerusgch","humerusdt","epaulegch","epauledt",
"flgch","fldt","figch","fidt","abdomen","poitrine",
"machoire","nez")var zone_atteinte : String
@export var have_indicateur : bool = false
@export var constante_associee : Constante_base  # optionnel, ex: fièvre -> temperature.tres
