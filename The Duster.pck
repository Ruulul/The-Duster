GDPC                �                                                                         T   res://.godot/exported/133200997/export-3fe9658478320f75563f27b2d0d7801c-room_map.scn`      �      L�3B��O4[�/�~e    X   res://.godot/exported/133200997/export-cafae89b2e9ebf0216ddfb8de4de99ea-test_scene.scn  �5      �	      g�>l1�>^��~"2A    ,   res://.godot/global_script_class_cache.cfg  p@            �Z��B�µx�D��)`�    H   res://.godot/imported/atlas.png-e13254db96f725589e2e34f2fc38292f.ctex           F      �{�+��iX�iKh2Ż    D   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex (      �      �̛�*$q�*�́     P   res://.godot/imported/simple_corridor.png-9bf9bdaadbf084228bfc8570b24c7f4f.ctex        �       �xqчS`�D��"3gH�       res://.godot/uid_cache.bin  @E      �      .ܡ����&3αPR�        res://ASSets/atlas.png.import   P      �       �f����28�q�"�~X    (   res://ASSets/simple_corridor.png.import �      �       �����%�Z� ޵j>       res://Components/building.gd�      #      ;y�t�܍�����*��       res://Components/room.gd�
      ~       X��\����H��y
    $   res://Components/room_map.tscn.remap�?      e       f9"�ʱ�E볔�!	�	       res://Duster.gd  "            M�~��'z��?>�       res://icon.svg  �A      �      C��=U���^Qu��U3       res://icon.svg.import    5      �       ��OwH�ŵ���i���       res://project.binaryG      %      P!��S4���rE|�9       res://test_scene.tscn.remap  @      g       �7Mz�Z�u����_(    L�oP�4�?p$GST2   @  @     ����               @@         RIFF  WEBPVP8L�  /?�Ow`�m�g׽��E��F��x�& �;̴�R��&@E��`����kpgA���~���mo$IN'l
M�),��0��J�3 $
Ma��(
�a����Ҋ�?�m$I�U��V���y��u���;���m��G3��7�z�t�� h/Í�h#@�4p���}
}�~�=�4�[4ߦ�N��4c��x[5�<�Q�ǜmc��=y�%o'YrKY�iRK��@���p��\1dq�E1`<n�d+ף��E�o7��~p�܍���|�6z�\�{��w��F�_��,���OO�c�Z
��kLbi(h�(dm( �'�,��E�B�\%�|�I�Y(w�/�@u}Q���&+�̒y�ڠy�8�hE�Eb-�%�X�!L�,��0iA���*
�$)jj>�um`t�=|F*r_q�Ϣ�*��4��*�"�d9%?H5�<�x���Q�{�d��.(˝D��P��Т@���������ɗL��l�)T#��&�5�p ^ҩ�z���*n ^X8Ogu�Ac��s���:�DL�U�Uq>l�]���8���J�wQsW��E@E�������%6�àp!�:�g\l�MK_W��Ʀ�S�\=������k=>�^�=��+���Y4�܅-��yE($�V�A��P��="RJȨ��Ehp��_HB��;�"/�Yb�îh���L��	)r����A_�/�hG�ρ���Q���Z0ګ�N�9�����N�9�����ή��>z	8��v�[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://dcxk6ebq1q7y3"
path="res://.godot/imported/atlas.png-e13254db96f725589e2e34f2fc38292f.ctex"
metadata={
"vram_texture": false
}
 �a䦚��RJ�w��GST2              ����                          �   RIFF~   WEBPVP8Lr   /�' Hq"�,Hq:�-L��l�?Z�W��,`�$�* ��Xn_�#�?k��{�m+���J*��>Br  ��A��hIӺ-�h�Mk
՚�JO�a�=��x;�v$���[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://bpq6hglv3fm2b"
path="res://.godot/imported/simple_corridor.png-9bf9bdaadbf084228bfc8570b24c7f4f.ctex"
metadata={
"vram_texture": false
}
 ��@Sextends Node2D
class_name Building

enum Type {
	Comercial,
	House
}

@export var initial_dust_rate: int
@export var dust_decay: int = 10
@export var rooms_count: int
@export var type: Type

@onready var dust_rate = initial_dust_rate
# Atlas positions of the 4 dirt levels
const dirt_levels = [Vector2i(2, 2), Vector2i(4, 2), Vector2i(2, 3), Vector2i(4, 3)]
const dirt_multiplier = 20
enum RoomMapLayers {
	Ground = 0,
	Walls = 1,
	Dirt = 2,
	Objects = 3
}

func _ready():
	for i in range(dirt_multiplier * dust_rate):
		dirt_loop(false)
	dirt_loop(true)

	dust_rate += 1
	decay()

func decay():
	dust_rate -= 1
	if dust_rate > 0:
		get_tree().create_timer(dust_decay).timeout.connect(decay)

func dirt_loop(do_loop):
	var ground: Array[Vector2i] = $RoomMap.get_used_cells(RoomMapLayers.Ground)
	var chosen_cell = ground.pick_random()
	var previous_dirt = $RoomMap.get_cell_atlas_coords(RoomMapLayers.Dirt, chosen_cell)
	# the find returns -1 if it is not there, thus with the +1 it puts the dirt at the first stage
	var next_dirt = dirt_levels[
			min(
					dirt_levels.find(previous_dirt) + 1, 
					dirt_levels.size() - 1
				)
		]
	$RoomMap.set_cell(RoomMapLayers.Dirt, chosen_cell, 0, next_dirt)
	if do_loop and dust_rate > 0:
		get_tree().create_timer(1.0/dust_rate).timeout.connect(func (): dirt_loop(true))
R	c�Չ�����lextends Object
class_name Room

@export var can_go_in: Array[Building.Type]
@export var dust_level: int
@export var size: int
�XRSRC                    PackedScene            ��������                                            V      resource_local_to_scene    resource_name 	   vertices 	   polygons 	   outlines 
   cell_size    script    texture    margins    separation    texture_region_size    use_texture_padding    0:0/size_in_atlas    0:0/next_alternative_id    0:0/0    0:0/0/texture_origin &   0:0/0/physics_layer_0/linear_velocity '   0:0/0/physics_layer_0/angular_velocity !   0:0/0/navigation_layer_0/polygon    0:0/0/script    0:0/1    0:0/1/texture_origin &   0:0/1/physics_layer_0/linear_velocity '   0:0/1/physics_layer_0/angular_velocity '   0:0/1/physics_layer_0/polygon_0/points    0:0/1/script    2:0/size_in_atlas    2:0/0 &   2:0/0/physics_layer_0/linear_velocity '   2:0/0/physics_layer_0/angular_velocity    2:0/0/script    3:0/size_in_atlas    3:0/0 &   3:0/0/physics_layer_0/linear_velocity '   3:0/0/physics_layer_0/angular_velocity    3:0/0/script    0:2/size_in_atlas    0:2/next_alternative_id    0:2/0    0:2/0/texture_origin &   0:2/0/physics_layer_0/linear_velocity '   0:2/0/physics_layer_0/angular_velocity !   0:2/0/navigation_layer_0/polygon    0:2/0/script    0:2/1    0:2/1/texture_origin &   0:2/1/physics_layer_0/linear_velocity '   0:2/1/physics_layer_0/angular_velocity '   0:2/1/physics_layer_0/polygon_0/points    0:2/1/script    2:2/size_in_atlas    2:2/0 &   2:2/0/physics_layer_0/linear_velocity '   2:2/0/physics_layer_0/angular_velocity    2:2/0/script    4:2/size_in_atlas    4:2/0 &   4:2/0/physics_layer_0/linear_velocity '   4:2/0/physics_layer_0/angular_velocity    4:2/0/script    2:3/size_in_atlas    2:3/0 &   2:3/0/physics_layer_0/linear_velocity '   2:3/0/physics_layer_0/angular_velocity    2:3/0/script    4:3/size_in_atlas    4:3/0 &   4:3/0/physics_layer_0/linear_velocity '   4:3/0/physics_layer_0/angular_velocity    4:3/0/script 
   tile_data    tile_shape    tile_layout    tile_offset_axis 
   tile_size    uv_clipping     physics_layer_0/collision_layer    navigation_layer_0/layers 
   sources/0    tile_proxies/source_level    tile_proxies/coords_level    tile_proxies/alternative_level 
   pattern_0 
   pattern_1 
   pattern_2 	   _bundled    
   Texture2D    res://ASSets/atlas.png ,�C�ܑ�e       local://NavigationPolygon_7c55c D
          local://NavigationPolygon_2qlb2 �
      !   local://TileSetAtlasSource_hxlku �         local://TileMapPattern_yjncc �         local://TileMapPattern_o2ttj �         local://TileMapPattern_aqmep u         local://TileSet_h2u6v T         local://PackedScene_wwd81 �         NavigationPolygon       %        �A           A  ��           �                                      %             �  ��           A  �A             NavigationPolygon       %        �A           A  ��           �                                      %             �  ��           A  �A             TileSetAtlasSource <                   -                               -       ����   
                                                    -             
                        %             �  ��           A  �A             -                      
                              -                    !   
           "          #      $   -         %         &          '   -       ����(   
           )          *            +      ,         -   -          .   
           /          0   %             �  ��           A  �A    1      2   -         3          4   
           5          6      7   -         8          9   
           :          ;      <   -         =          >   
           ?          @      A   -         B          C   
           D          E               TileMapPattern    F                                                                                                                 TileMapPattern    F       0                                                                                                                                                                              TileMapPattern    F       -                                                                                                                                                                      TileSet 	   G         J   -          L         M         N            R            S            T                     PackedScene    U      	         names "         RoomMap    y_sort_enabled 	   tile_set    format    layer_0/name    layer_0/y_sort_enabled    layer_1/name    layer_1/enabled    layer_1/modulate    layer_1/y_sort_enabled    layer_1/y_sort_origin    layer_1/z_index    layer_1/tile_data    layer_2/name    layer_2/enabled    layer_2/modulate    layer_2/y_sort_enabled    layer_2/y_sort_origin    layer_2/z_index    layer_2/tile_data    layer_3/name    layer_3/enabled    layer_3/modulate    layer_3/y_sort_enabled    layer_3/y_sort_origin    layer_3/z_index    layer_3/tile_data    TileMap    	   variants                                  Ground       Walls      �?  �?  �?  �?                           Dirt       Objects       node_count             nodes     ;   ��������       ����                                                      	       
                     	                                            
                                                   conn_count              conns               node_paths              editable_instances              version             RSRC{[ZQ�extends CharacterBody2D

@export var speed = 1.0
@export var map: TileMap

@onready var navigation_agent = $NavigationAgent2D

var states: Dictionary = {
	move = move,
	clear_dust = clear_dust,
	wait = wait,
	cleaning_dust = func (): pass,
}
@onready var state: Callable = states.wait


func set_target(target: Vector2) -> void:
	navigation_agent.target_position = target

func _physics_process(delta):
	state.call()

func wait() -> void:
	$ColorRect.color = Color.PURPLE
	if Input.is_action_just_pressed("select"):
		set_target(get_viewport().get_mouse_position())
		state = states.move

func clear_dust() -> void:
	$ColorRect.color = Color.DARK_KHAKI
	state = states.cleaning_dust

	get_tree().create_timer(0.5).timeout.connect(func ():
			var current_tile_coords = map.local_to_map(map.to_local(global_position))
			var current_dirt = map.get_cell_atlas_coords(Building.RoomMapLayers.Dirt, current_tile_coords)
			var previous_dirt_index = Building.dirt_levels.find(current_dirt) - 1
			if previous_dirt_index >= 0:
				var previous_dirt = Building.dirt_levels[previous_dirt_index]
				map.set_cell(Building.RoomMapLayers.Dirt, current_tile_coords, 0, previous_dirt)
			else:
				map.set_cell(Building.RoomMapLayers.Dirt, current_tile_coords, -1, Vector2i(-1, -1))
			state = states.wait
	)

func move() -> void:
	if navigation_agent.is_navigation_finished():
		state = states.clear_dust
		return
	$ColorRect.color = Color.DARK_BLUE
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * speed * 32.0
	move_and_slide()
���j�~����;��GST2   �   �      ����               � �        �  RIFF�  WEBPVP8L�  /������!"2�H�$�n윦���z�x����դ�<����q����F��Z��?&,
ScI_L �;����In#Y��0�p~��Z��m[��N����R,��#"� )���d��mG�������ڶ�$�ʹ���۶�=���mϬm۶mc�9��z��T��7�m+�}�����v��ح�m�m������$$P�����එ#���=�]��SnA�VhE��*JG�
&����^x��&�+���2ε�L2�@��		��S�2A�/E���d"?���Dh�+Z�@:�Gk�FbWd�\�C�Ӷg�g�k��Vo��<c{��4�;M�,5��ٜ2�Ζ�yO�S����qZ0��s���r?I��ѷE{�4�Ζ�i� xK�U��F�Z�y�SL�)���旵�V[�-�1Z�-�1���z�Q�>�tH�0��:[RGň6�=KVv�X�6�L;�N\���J���/0u���_��U��]���ǫ)�9��������!�&�?W�VfY�2���༏��2kSi����1!��z+�F�j=�R�O�{�
ۇ�P-�������\����y;�[ ���lm�F2K�ޱ|��S��d)é�r�BTZ)e�� ��֩A�2�����X�X'�e1߬���p��-�-f�E�ˊU	^�����T�ZT�m�*a|	׫�:V���G�r+�/�T��@U�N׼�h�+	*�*sN1e�,e���nbJL<����"g=O��AL�WO!��߈Q���,ɉ'���lzJ���Q����t��9�F���A��g�B-����G�f|��x��5�'+��O��y��������F��2�����R�q�):VtI���/ʎ�UfěĲr'�g�g����5�t�ۛ�F���S�j1p�)�JD̻�ZR���Pq�r/jt�/sO�C�u����i�y�K�(Q��7őA�2���R�ͥ+lgzJ~��,eA��.���k�eQ�,l'Ɨ�2�,eaS��S�ԟe)��x��ood�d)����h��ZZ��`z�պ��;�Cr�rpi&��՜�Pf��+���:w��b�DUeZ��ڡ��iA>IN>���܋�b�O<�A���)�R�4��8+��k�Jpey��.���7ryc�!��M�a���v_��/�����'��t5`=��~	`�����p\�u����*>:|ٻ@�G�����wƝ�����K5�NZal������LH�]I'�^���+@q(�q2q+�g�}�o�����S߈:�R�݉C������?�1�.��
�ڈL�Fb%ħA ����Q���2�͍J]_�� A��Fb�����ݏ�4o��'2��F�  ڹ���W�L |����YK5�-�E�n�K�|�ɭvD=��p!V3gS��`�p|r�l	F�4�1{�V'&����|pj� ߫'ş�pdT�7`&�
�1g�����@D�˅ �x?)~83+	p �3W�w��j"�� '�J��CM�+ �Ĝ��"���4� ����nΟ	�0C���q'�&5.��z@�S1l5Z��]�~L�L"�"�VS��8w.����H�B|���K(�}
r%Vk$f�����8�ڹ���R�dϝx/@�_�k'�8���E���r��D���K�z3�^���Vw��ZEl%~�Vc���R� �Xk[�3��B��Ğ�Y��A`_��fa��D{������ @ ��dg�������Mƚ�R�`���s����>x=�����	`��s���H���/ū�R�U�g�r���/����n�;�SSup`�S��6��u���⟦;Z�AN3�|�oh�9f�Pg�����^��g�t����x��)Oq�Q�My55jF����t9����,�z�Z�����2��#�)���"�u���}'�*�>�����ǯ[����82һ�n���0�<v�ݑa}.+n��'����W:4TY�����P�ר���Cȫۿ�Ϗ��?����Ӣ�K�|y�@suyo�<�����{��x}~�����~�AN]�q�9ޝ�GG�����[�L}~�`�f%4�R!1�no���������v!�G����Qw��m���"F!9�vٿü�|j�����*��{Ew[Á��������u.+�<���awͮ�ӓ�Q �:�Vd�5*��p�ioaE��,�LjP��	a�/�˰!{g:���3`=`]�2��y`�"��N�N�p���� ��3�Z��䏔��9"�ʞ l�zP�G�ߙj��V�>���n�/��׷�G��[���\��T��Ͷh���ag?1��O��6{s{����!�1�Y�����91Qry��=����y=�ٮh;�����[�tDV5�chȃ��v�G ��T/'XX���~Q�7��+[�e��Ti@j��)��9��J�hJV�#�jk�A�1�^6���=<ԧg�B�*o�߯.��/�>W[M���I�o?V���s��|yu�xt��]�].��Yyx�w���`��C���pH��tu�w�J��#Ef�Y݆v�f5�e��8��=�٢�e��W��M9J�u�}]釧7k���:�o�����Ç����ս�r3W���7k���e�������ϛk��Ϳ�_��lu�۹�g�w��~�ߗ�/��ݩ�-�->�I�͒���A�	���ߥζ,�}�3�UbY?�Ӓ�7q�Db����>~8�]
� ^n׹�[�o���Z-�ǫ�N;U���E4=eȢ�vk��Z�Y�j���k�j1�/eȢK��J�9|�,UX65]W����lQ-�"`�C�.~8ek�{Xy���d��<��Gf�ō�E�Ӗ�T� �g��Y�*��.͊e��"�]�d������h��ڠ����c�qV�ǷN��6�z���kD�6�L;�N\���Y�����
�O�ʨ1*]a�SN�=	fH�JN�9%'�S<C:��:`�s��~��jKEU�#i����$�K�TQD���G0H�=�� �d�-Q�H�4�5��L�r?����}��B+��,Q�yO�H�jD�4d�����0*�]�	~�ӎ�.�"����%
��d$"5zxA:�U��H���H%jس{���kW��)�	8J��v�}�rK�F�@�t)FXu����G'.X�8�KH;���[ �c	��x��B[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://cutu55y51e54"
path="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.ctex"
metadata={
"vram_texture": false
}
 RSRC                    PackedScene            ��������                                            	      .. 	   Building    RoomMap    resource_local_to_scene    resource_name    custom_solver_bias    size    script 	   _bundled       Script    res://Components/building.gd ��������   PackedScene    res://Components/room_map.tscn �H�7#��e   Script    res://Duster.gd ��������      local://RectangleShape2D_hidwb �         local://PackedScene_gvm4d          RectangleShape2D       
     @A  �@         PackedScene          	         names "         test_scene 	   position    Node2D 	   Building    script    initial_dust_rate    RoomMap    layer_0/tile_data    Duster    z_index    y_sort_enabled    speed    map    CharacterBody2D 
   ColorRect    offset_left    offset_top    offset_right    offset_bottom    color    CollisionShape2D    shape    NavigationAgent2D    path_desired_distance    target_desired_distance    path_max_distance    	   variants       
     C  C                             �   ��          ����        ����        ����          ��          ��          ��                    ����        ��          ��          ��        ����        ����        ����        ����         ��                                         ��         ��         ��         ��          ����         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��         ��                              ��         ��                              ��                                                        @                      �     ��      A     �@   ���=���=��?  �?               �A      node_count             nodes     U   ��������       ����                            ����                          ���                                 ����   	      
                    @	                    ����      
                                            ����                          ����                               conn_count              conns               node_paths              editable_instances              version             RSRC��ӎ� �����[remap]

path="res://.godot/exported/133200997/export-3fe9658478320f75563f27b2d0d7801c-room_map.scn"
V����a��[remap]

path="res://.godot/exported/133200997/export-cafae89b2e9ebf0216ddfb8de4de99ea-test_scene.scn"
O�`� �list=Array[Dictionary]([{
"base": &"Node2D",
"class": &"Building",
"icon": "",
"language": &"GDScript",
"path": "res://Components/building.gd"
}, {
"base": &"Object",
"class": &"Room",
"icon": "",
"language": &"GDScript",
"path": "res://Components/room.gd"
}])
�a_������<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
$�z��]ŕ$�   ,�C�ܑ�e   res://ASSets/atlas.png�ʙ ��60    res://ASSets/simple_corridor.png�H�7#��e   res://Components/room_map.tscnYK�����   res://icon.svg�]�ݍ6�j   res://test_scene.tscnN��,>�v"   res://Builds/web_build.144x144.pngN��߲P�.+   res://Builds/web_build.apple-touch-icon.png���ۅ�S|   res://Builds/web_build.icon.png�����L"   res://Builds/web_build.512x512.png�rRv���6"   res://Builds/web_build.180x180.png�p}a��v   res://Builds/web_build.png�lA�/�ECFG      application/config/name      
   The Duster     application/run/main_scene          res://test_scene.tscn      application/config/features(   "         4.1    GL Compatibility       application/config/icon         res://icon.svg  "   display/window/size/viewport_width      �  #   display/window/size/viewport_height      ,  )   display/window/size/window_width_override      �  *   display/window/size/window_height_override      �     display/window/stretch/mode         viewport   display/window/stretch/aspect      
   keep_width     input/select�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask          position     wC  �A   global_position      {C  xB   factor       �?   button_index         canceled          pressed          double_click          script      9   rendering/textures/canvas_textures/default_texture_filter          #   rendering/renderer/rendering_method         gl_compatibility*   rendering/renderer/rendering_method.mobile         gl_compatibility�i�����I�