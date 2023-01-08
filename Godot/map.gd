extends Control

@onready var SOCIABILITY_OPTION = $Sidebar/MarginContainer/VSplitContainer/PanelContainer/VBoxContainer/MarginContainer3/HSplitContainer/OptionButton
@onready var WORSHIP_OPTION = $Sidebar/MarginContainer/VSplitContainer/PanelContainer/VBoxContainer/MarginContainer4/HSplitContainer/OptionButton
@onready var TIME_LABEL = $TimeBar/HBoxContainer/MarginContainer/Label
@onready var TIME1_HIGHLIGHT = $TimeBar/HBoxContainer/CenterContainer/PanelContainer
@onready var TIME2_HIGHLIGHT = $TimeBar/HBoxContainer/CenterContainer2/PanelContainer
@onready var TIME4_HIGHLIGHT = $TimeBar/HBoxContainer/CenterContainer3/PanelContainer

# Event rate: 1 / 10 if 0.015, 1 / 5 if 0.05, 14.6 for 0.007, 19.5 for 0.004

var base_tick_rate: float = 18000.0
var tick_rate_mod: int = 1
var EVENT_RATE_ADD = 0.01
var event_rate = EVENT_RATE_ADD

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
func _process(delta):
    agg += delta * base_tick_rate * tick_rate_mod
    if agg > proc:
        advance_state(agg)
        agg = 0.0
    update_time()


func advance_state(s):    
    var last_date : Dictionary = Time.get_date_dict_from_unix_time(int(GameData.data["Time"]));
    GameData.data["Time"] += s
    var curr_date : Dictionary = Time.get_date_dict_from_unix_time(int(GameData.data["Time"]));
    var day_frac: float = s / 24.0 / 3600.0
    
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
    
    # Apply deconversion
    for region in GameData.data["Regions"]:
        var reg_data = GameData.data["Regions"][region]
        for category in reg_data["Categories"]:
            var cat_data = reg_data["Categories"][category]
            var deconverted_me = cat_data[0] * (1.0 - reg_data["FollowerDefense"]) * day_frac
            deconverted_me = floor(deconverted_me) if randf() > fmod(deconverted_me, 1.0) else ceil(deconverted_me)
            var deconverted_bro = cat_data[1] * (1.0 - reg_data["TentDefense"]) * day_frac / GameData.data["Difficulty"]
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
                var to_convert_me = reg_totals[region][0] / float(reg_totals[region][3]) * cat_data[2] * (cat_data[3] * day_frac)
                to_convert_me = floor(to_convert_me) if randf() > fmod(to_convert_me, 1.0) else ceil(to_convert_me)
                
                var to_convert_bro = reg_totals[region][1] / float(reg_totals[region][3]) * cat_data[2] * (cat_data[4] * day_frac) * GameData.data["Difficulty"]
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
                
                var to_convert_me = (both_data[0] + cat_data[0]) * cat_data[2] / float(cat_total) * (cat_data[3] * day_frac)
                to_convert_me += soc_totals[category][0] / float(soc_totals[category][3]) * cat_data[2] * (cat_data[3] * cat_data[3] * day_frac)
                to_convert_me = floor(to_convert_me) if randf() > fmod(to_convert_me, 1.0) else ceil(to_convert_me)
                
                var to_convert_bro = (both_data[1] + cat_data[1]) / float(cat_total) * cat_data[2] * (cat_data[4] * day_frac) * GameData.data["Difficulty"]
                to_convert_bro += soc_totals[category][1] / float(soc_totals[category][3]) * cat_data[2] * (cat_data[4] * cat_data[4] * day_frac) * GameData.data["Difficulty"]
                to_convert_bro = floor(to_convert_bro) if randf() > fmod(to_convert_bro, 1.0) else ceil(to_convert_bro)
                
                cat_data[0] += to_convert_me
                cat_data[1] += to_convert_bro
                cat_data[2] = max(0, cat_data[2] - to_convert_bro - to_convert_me)
                
                var to_convert_me_both = (both_data[0] + cat_data[0]) / float(cat_total) * both_data[2] * (cat_data[3] * day_frac)
                to_convert_me_both += soc_totals[category][0] / float(soc_totals[category][3]) * both_data[2] * (cat_data[3] * cat_data[3] * day_frac)
                to_convert_me_both = floor(to_convert_me_both) if randf() > fmod(to_convert_me_both, 1.0) else ceil(to_convert_me_both)
                
                var to_convert_bro_both = (both_data[1] + cat_data[1]) / float(cat_total) * both_data[2] * (cat_data[4] * day_frac) * GameData.data["Difficulty"]
                to_convert_bro_both += soc_totals[category][1] / float(soc_totals[category][3]) * both_data[2] * (cat_data[4] * cat_data[4] * day_frac) * GameData.data["Difficulty"]
                to_convert_bro_both = floor(to_convert_bro_both) if randf() > fmod(to_convert_bro_both, 1.0) else ceil(to_convert_bro_both)
                
                both_data[0] += to_convert_me_both
                both_data[1] += to_convert_bro_both
                both_data[2] = max(0, both_data[2] - to_convert_bro_both - to_convert_me_both)
            
    # Apply general
    for region in GameData.data["Regions"]:
        var reg_data = GameData.data["Regions"][region]
        for category in reg_data["Categories"]:
            var cat_data = reg_data["Categories"][category]
            var to_convert_me = totals[0] / float(totals[3]) * cat_data[2] * (reg_data["Categories"][category][3] * GameData.GLOBAL_CONVERT_RATE * day_frac)
            if cat_data[0] > 0:
                to_convert_me += randf() * day_frac * GameData.START_FLAT_BOOST
            to_convert_me = floor(to_convert_me) if randf() > fmod(to_convert_me, 1.0) else ceil(to_convert_me)
            
            var to_convert_bro = totals[1] / float(totals[3]) * cat_data[2] * (reg_data["Categories"][category][4] * GameData.GLOBAL_ENEMY_CONVERT_RATE * day_frac) * GameData.data["Difficulty"]
            if cat_data[1] > 0:
                to_convert_bro += randf() * day_frac * GameData.START_FLAT_BOOST
            to_convert_bro = floor(to_convert_bro) if randf() > fmod(to_convert_bro, 1.0) else ceil(to_convert_bro)
            
            cat_data[0] += to_convert_me
            cat_data[1] += to_convert_bro
            cat_data[2] = max(0, cat_data[2] - to_convert_bro - to_convert_me)
    
    if last_date["day"] != curr_date["day"]:
        if randf() < event_rate:
            print("Do a random event")
        else:
            event_rate += EVENT_RATE_ADD


func _on_shop_button(region):
    get_tree().get_first_node_in_group("shop").display_region(region)


func _on_harvest(region, count):
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
    spawn_ghosts(region, log(count) / log(5.0))


func spawn_ghosts(region, count):
    pass
