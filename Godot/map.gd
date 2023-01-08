extends Control

@onready var GHOST_SCENE = load("res://Ghost.tscn")

@onready var SOCIABILITY_OPTION = $Sidebar/MarginContainer/VSplitContainer/PanelContainer/VBoxContainer/MarginContainer3/HSplitContainer/OptionButton
@onready var WORSHIP_OPTION = $Sidebar/MarginContainer/VSplitContainer/PanelContainer/VBoxContainer/MarginContainer4/HSplitContainer/OptionButton
@onready var TIME_LABEL = $TimeBar/HBoxContainer/MarginContainer/Label
@onready var TIME1_HIGHLIGHT = $TimeBar/HBoxContainer/CenterContainer/PanelContainer
@onready var TIME2_HIGHLIGHT = $TimeBar/HBoxContainer/CenterContainer2/PanelContainer
@onready var TIME4_HIGHLIGHT = $TimeBar/HBoxContainer/CenterContainer3/PanelContainer

# Event rate: 1 / 10 if 0.015, 1 / 5 if 0.05, 14.6 for 0.007, 19.5 for 0.004

var base_tick_rate: float = 18000.0
var tick_rate_mod: int = 1
var STRESS_DECAY = 0.93
var days_since_event = 0

func set_tick_rate_mod(new_mod):
    tick_rate_mod = new_mod
    TIME1_HIGHLIGHT.visible = new_mod == 1
    TIME2_HIGHLIGHT.visible = new_mod == 2
    TIME4_HIGHLIGHT.visible = new_mod == 4


func update_time():
    var time : Dictionary = Time.get_datetime_dict_from_unix_time(int(GameData.data["Time"]));
    var display_string : String = "%d/%02d/%02d %02d:%02d" % [time["year"], time["month"], time["day"], time["hour"], 0];
    TIME_LABEL.text = display_string


# Called every frame. 'delta' is the elapsed time since the previous frame.
var agg = 0.0
var proc = 3600

var autosave_timer = 0.0
var autosave_freq = 20.0
func _process(delta):
    agg += delta * base_tick_rate * tick_rate_mod
    if agg > proc:
        advance_state(agg)
        agg = 0.0
    update_time()
    
    autosave_timer += delta
    if autosave_timer > autosave_freq:
        autosave_timer = 0
        GameData.save()


func advance_state(s):    
    var last_date : Dictionary = Time.get_date_dict_from_unix_time(int(GameData.data["Time"]));
    GameData.data["Time"] += s
    var curr_date : Dictionary = Time.get_date_dict_from_unix_time(int(GameData.data["Time"]));
    var day_frac: float = s / 24.0 / 3600.0
    
    var curr_stress = GameData.data["Edicts"][0] + GameData.data["Edicts"][1]
    if curr_stress == 0:
        curr_stress = 0.0
    elif curr_stress == 1:
        curr_stress = 0.15
    elif curr_stress == 2:
        curr_stress = 0.3
    elif curr_stress == 3:
        curr_stress = 0.6
    elif curr_stress == 4:
        curr_stress = 0.9
    GameData.data["Stress"] = lerp(curr_stress, GameData.data["Stress"], pow(STRESS_DECAY, day_frac))
    
    var reg_acos = {}
    for region in GameData.data["Regions"]:
        reg_acos[region] = 0
    for acolyte in GameData.data["Acolytes"]:
        if acolyte != "":
            reg_acos[acolyte] += 1
    
    var reg_odds = {}
    for region in GameData.data["Regions"]:
        var reg_data = GameData.data["Regions"][region]
        reg_odds[region] = {
            "Defense": [reg_data["FollowerDefense"], reg_data["TentDefense"]]
        }
        for category in reg_data["Categories"]:
            var cat_data = reg_data["Categories"][category]
            reg_odds[region][category] = [cat_data[3], cat_data[4]]
        for i in range(len(reg_data["Boosts"])):
            var boost = reg_data["Boosts"][i]
            reg_odds[region][boost[0]][boost[1]] *= boost[3]
        for i in range(len(reg_data["Boosts"])):
            var boost = reg_data["Boosts"][i]
            reg_odds[region][boost[0]][boost[1]] += boost[4]
    for acolyte in GameData.data["Acolytes"]:
        if acolyte != "":
            for category in reg_odds[acolyte]:
                if category != "Defense":
                    reg_odds[acolyte][category][0] *= 1.2
    var def_mult = 1.0
    if GameData.data["Edicts"][1] == 0:
        def_mult = 3.0
    elif GameData.data["Edicts"][1] == 2:
        def_mult = 0.33
    for region in reg_odds:
        reg_odds[region]["Defense"][0] *= def_mult

    var spread_mult = 1.0
    if GameData.data["Edicts"][0] == 0:
        spread_mult = 0.8
    elif GameData.data["Edicts"][0] == 2:
        spread_mult = 1.5
    for region in reg_odds:
        for category in reg_odds[region]:
            if category != "Defense":
                reg_odds[region][category][0] *= spread_mult
    
    var soc_totals = {"Offline": [0, 0, 0, 0], "WeTalk": [0, 0, 0, 0], "V Kontent": [0, 0, 0, 0], "Facepage": [0, 0, 0, 0], "Twittly": [0, 0, 0, 0]}
    var reg_totals = {}
    var totals = [0, 0, 0, 0]
    for region in GameData.data["Regions"]:
        var reg_data = GameData.data["Regions"][region]
        reg_totals[region] = [0, 0, 0, 0]
        for category in reg_data["Categories"]:
            var cat_data = reg_data["Categories"][category]
            for i in range(3):
                reg_totals[region][i] += cat_data[i]
                reg_totals[region][3] += cat_data[i]
                totals[i] += cat_data[i]
                totals[3] += cat_data[i]
            if category != "Both":
                for i in range(3):
                    soc_totals[category][i] += cat_data[i]
                    soc_totals[category][3] += cat_data[i]
            if category != "Both" and category != "Offline":
                for i in range(3):
                    soc_totals[category][i] += reg_data["Categories"]["Both"][i]
                    soc_totals[category][3] += reg_data["Categories"]["Both"][i]
    
    if GameData.data["Stress"] > 0.5:
        var death_rate = pow(max(0, GameData.data["Stress"] - 0.5), 2.0)
        for region in GameData.data["Regions"]:
            var harvest_count = (reg_totals[region][0] - 1) * death_rate
            for i in range(reg_acos[region]):
                harvest_count *= 0.9
            harvest_count = floor(harvest_count)
            if harvest_count > 0:
                _on_harvest(region, harvest_count)
    
    # Apply deconversion
    for region in GameData.data["Regions"]:
        var reg_data = GameData.data["Regions"][region]
        for category in reg_data["Categories"]:
            var cat_data = reg_data["Categories"][category]
            var deconverted_me = cat_data[0] * reg_odds[region]["Defense"][0] * day_frac
            deconverted_me = floor(deconverted_me) if randf() > fmod(deconverted_me, 1.0) else ceil(deconverted_me)
            for i in range(reg_acos[region]):
                deconverted_me *= 0.9
            var deconverted_bro = cat_data[1] * reg_odds[region]["Defense"][1] * day_frac / GameData.data["Difficulty"]
            deconverted_bro = floor(deconverted_bro) if randf() > fmod(deconverted_bro, 1.0) else ceil(deconverted_bro)
            cat_data[0] = max(1 if cat_data[0] > 0 else 0, cat_data[0] - deconverted_me)
            cat_data[1] = max(1 if cat_data[1] > 0 else 0, cat_data[1] - deconverted_bro)
            cat_data[2] += deconverted_me + deconverted_bro
            
    # Apply social media
    for region in GameData.data["Regions"]:
        var reg_data = GameData.data["Regions"][region]
        for category in reg_data["Categories"]:
            var cat_data = reg_data["Categories"][category]
            if category == "Offline":
                var to_convert_me = reg_totals[region][0] / float(reg_totals[region][3]) * cat_data[2] * (reg_odds[region][category][0] * day_frac)
                to_convert_me = floor(to_convert_me) if randf() > fmod(to_convert_me, 1.0) else ceil(to_convert_me)
                
                var to_convert_bro = reg_totals[region][1] / float(reg_totals[region][3]) * cat_data[2] * (reg_odds[region][category][1] * day_frac) * GameData.data["Difficulty"]
                to_convert_bro = floor(to_convert_bro) if randf() > fmod(to_convert_bro, 1.0) else ceil(to_convert_bro)
                
                cat_data[0] += to_convert_me
                cat_data[1] += to_convert_bro
                cat_data[2] = max(0, cat_data[2] - to_convert_bro - to_convert_me)
            elif category == "Both":
                pass
            else:
                var both_data = reg_data["Categories"]["Both"]
                var cat_total = 0
                for i in range(3):
                    cat_total += cat_data[i]
                    cat_total += both_data[i]
                
                var to_convert_me = (both_data[0] + cat_data[0]) * cat_data[2] / float(cat_total) * (reg_odds[region][category][0] * day_frac)
                to_convert_me += soc_totals[category][0] / float(soc_totals[category][3]) * cat_data[2] * pow(reg_odds[region][category][0], 2) * day_frac
                to_convert_me = floor(to_convert_me) if randf() > fmod(to_convert_me, 1.0) else ceil(to_convert_me)
                
                var to_convert_bro = (both_data[1] + cat_data[1]) / float(cat_total) * cat_data[2] * (reg_odds[region][category][1] * day_frac) * GameData.data["Difficulty"]
                to_convert_bro += soc_totals[category][1] / float(soc_totals[category][3]) * cat_data[2] * pow(reg_odds[region][category][1], 2) * day_frac * GameData.data["Difficulty"]
                to_convert_bro = floor(to_convert_bro) if randf() > fmod(to_convert_bro, 1.0) else ceil(to_convert_bro)
                
                cat_data[0] += to_convert_me
                cat_data[1] += to_convert_bro
                cat_data[2] = max(0, cat_data[2] - to_convert_bro - to_convert_me)
                
                var to_convert_me_both = (both_data[0] + cat_data[0]) / float(cat_total) * both_data[2] * (reg_odds[region][category][0] * day_frac)
                to_convert_me_both += soc_totals[category][0] / float(soc_totals[category][3]) * both_data[2] * pow(reg_odds[region][category][0], 2) * day_frac
                to_convert_me_both = floor(to_convert_me_both) if randf() > fmod(to_convert_me_both, 1.0) else ceil(to_convert_me_both)
                
                var to_convert_bro_both = (both_data[1] + cat_data[1]) / float(cat_total) * both_data[2] * (reg_odds[region][category][1] * day_frac) * GameData.data["Difficulty"]
                to_convert_bro_both += soc_totals[category][1] / float(soc_totals[category][3]) * both_data[2] * pow(reg_odds[region][category][1], 2) * day_frac * GameData.data["Difficulty"]
                to_convert_bro_both = floor(to_convert_bro_both) if randf() > fmod(to_convert_bro_both, 1.0) else ceil(to_convert_bro_both)
                
                both_data[0] += to_convert_me_both
                both_data[1] += to_convert_bro_both
                both_data[2] = max(0, both_data[2] - to_convert_bro_both - to_convert_me_both)
            
    # Apply general
    for region in GameData.data["Regions"]:
        var reg_data = GameData.data["Regions"][region]
        for category in reg_data["Categories"]:
            var cat_data = reg_data["Categories"][category]
            var to_convert_me = totals[0] / float(totals[3]) * cat_data[2] * (reg_odds[region][category][0] * GameData.GLOBAL_CONVERT_RATE * day_frac)
            if cat_data[0] > 0 or reg_acos[region] > 0:
                to_convert_me += randf() * day_frac * GameData.START_FLAT_BOOST
            to_convert_me = floor(to_convert_me) if randf() > fmod(to_convert_me, 1.0) else ceil(to_convert_me)
            
            var to_convert_bro = totals[1] / float(totals[3]) * cat_data[2] * (reg_odds[region][category][1] * GameData.GLOBAL_ENEMY_CONVERT_RATE * day_frac) * GameData.data["Difficulty"]
            if cat_data[1] > 0 or reg_acos[region] > 0:
                to_convert_bro += randf() * day_frac * GameData.START_FLAT_BOOST
            to_convert_bro = floor(to_convert_bro) if randf() > fmod(to_convert_bro, 1.0) else ceil(to_convert_bro)
            
            cat_data[0] += to_convert_me
            cat_data[1] += to_convert_bro
            cat_data[2] = max(0, cat_data[2] - to_convert_bro - to_convert_me)
    
    if last_date["day"] != curr_date["day"]:
        for region in GameData.data["Regions"]:
            var boosts = GameData.data["Regions"][region]["Boosts"]
            var i = 0
            while i < len(boosts):
                boosts[i][2] -= 1
                if boosts[i][2] <= 0:
                    boosts.remove_at(i)
                else:
                    i += 1
        
        var ran_event = get_tree().get_first_node_in_group("news").run_possible_event(last_date["year"], last_date["month"], last_date["day"], false, days_since_event)
        if ran_event:
            days_since_event = 0
        else:
            days_since_event += 1


func _on_shop_button(region):
    get_tree().get_first_node_in_group("shop").display_region(region)


func _on_harvest(region, count):
    if count == 0:
        return
    var data = GameData.data["Regions"][region]
    var region_total = 0
    for category in data["Categories"]:
        region_total += data["Categories"][category][0]
    var harvested = 0
    for category in data["Categories"]:
        var to_harvest = floor(data["Categories"][category][0] / region_total * count)
        data["Categories"][category][0] -= to_harvest
        harvested += to_harvest
    var categories = data["Categories"].keys()
    while harvested < count:
        var ran = randi_range(0, len(categories) - 1)
        if data["Categories"][categories[ran]][0] > 0:
            data["Categories"][categories[ran]][0] -= 1
            harvested += 1
    GameData.data["Souls"] += count
    data["HarvestedToday"] += count
    spawn_ghosts(region, min(count, max(1, log(count) / log(1.5))))


var SPAWN_DIST = 110.0
func spawn_ghosts(region, count):
    var spawn_point = get_node(String(region)).get_child(1).global_position
    for i in range(count):
        var angle = randf_range(0, TAU)
        var dist = SPAWN_DIST * randf()
        spawn_point += Vector2(sin(angle), cos(angle)) * dist
        var ghost = GHOST_SCENE.instantiate()
        $Ghosts.add_child(ghost)
        ghost.global_position = spawn_point
