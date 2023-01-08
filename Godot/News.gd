extends PanelContainer

@onready var FLAVOR_LABEL = $PopUp/PanelContainer/MarginContainer/HBoxContainer/Label2
@onready var EFFECT_LABEL = $PopUp/PanelContainer/MarginContainer/HBoxContainer/Label3

var display_time = 0
var delay = 1000

var articles = [
    ["You harvested a lot of souls today. Bad news, though: one of them was a popular musician, and now you've got a virtual army coming after posts about you.", "Social media posts are less effective"],
    ["Your brother harvested some souls, and now everyone's mad at Eldritch dieties across the board. Can't believe he's messing this up for you, again.", "You both have a harder time recruiting"],
    ["Headlines across the world lamented the loss of X of your followers yesterday, but they somehow blamed your brother and called them martyrs. Don't they realize the whole point of having followers is to take advantage of them?", "Your brother has a harder time recruiting"],
    ["News reports of spontaneous deaths have caused people to become more religious.", "People's religious affiliations are more likely to change"],
    ["Your soul harvesting has convinced some people that this is the rapture.", "You gain additional followers"],
    ["Posts about charity work have blown up for the holidays. Waves of generosity and strange behavior sweep across the planet. Disgusting.", "People are less likely to be converted"],
    ["Major grants have been offered to anyone trying to prove that Eldritch beings are nonsense. Unfortunately for them, while you may not make much sense to a human, you do exist.", "Nothing. Yet..."],
    ["A major research university claims to have proven that you can't exist. Your followers don't buy it, but the masses do.", "It's harder to influence people."],
    ["You prepared for the War on Christmas you heard about but there wasn't really much of an uptick in combat. Strange.", ""],
    ["Site X's algorithm has realized posts about you destroying human civilization drive tons of engagement. You're now being shown to all the new and most vulnerable users.", "Posts on Site X are temporarily more effective"],
    ["A famous author published a book about you! It was immediately banned in 17 countries, but there are plenty of other countries.", "People are more likely to hear about you offline"],
    ["A secret order has assassinated your most followed poster on Site X. Engagement on that platform spikes but that can't be good in the long run.", "Site X engagement falling soon"],
    ["A secret order failed to assassinate one of your most prolific posters on Site X, and they're milking every like they can out of it.", "Engagement on Site X temporarily boosted"],
    ["A secret order has been attacking your followers. It was a bloodbath, which reminded you it had been a while since you last had a relaxing soak.", "Some of your followers have died"],
    ["A human has managed to grasp your true nature without going mad. Took 'em a few tries to realize you can't just tell other people, though.", "You've gained an acolyte"],
    ["Followers of Tentacruelism have started attacking your followers. You'll have to keep another eye on the situation.", "Some of your followers have died"],
    ["Your brother's singing again, and it sounds horrible even though sound doesn't travel in space. His followers seem to be enjoying it, at least.", "Your brother's recruitment is up"],
    ["You got distracted watching every reality TV show mankind has ever made at once and missed the news. Woops.", "Uh... hopefully nothing important?"],
    ["A popular new TV show makes people believe your acts are just viral marketing.", "Your followers are less devoted to you."],
    ["Your brother told all his followers about that time you burned yourself eating a sun, and they all laughed at you. Really not a good look for you, gotta say. Maybe wait for it to cool down next time first, yeah?", "Some of your followers have converted to Tentacruelism"],
    ["Some misguided optometrists decided you were their patron god, and you aren't about to correct them.", "You have gained followers"],
    ["Governments have become wary of your influence and began issuing warning pamphlets to parents about their teenagers. Parents are now very wary of certain completely unrelated acryonyms.", "It's harder to attract new followers"],
    ["All eye emojis have been banned on Site X. Blatant discrimination, frankly.", "Your social media posts are less effective"],
    ["Your brother somehow convinced people tentacle hats were fashionable, and now they're all over the place. That's gotta help his numbers. ", "Your brother has an easier time recruiting"],
    ["So many of your followers have died that you're having trouble converting new followers. But hey, if they can't handle you at your worst, do they deserve you at your slightly less bad?", "You have a harder time recruiting"],
    ["", ""],
    ["", ""],
    ["", ""],
    ["", ""],
    ["", ""],
    ["", ""],
]

var OG_RANDOMS = [9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
var randoms = OG_RANDOMS.duplicate()
var OG_HARVESTS = [0, 1, 2, 3, 4, 24]
var harvests = OG_HARVESTS.duplicate()

var EVENT_RATE = 0.01

func run_possible_event(year, month, day, harvest_eligible, days_since_event):
    var event_number = -1
    if month == 12 and day == 25:
        event_number = 8
    elif month == 12 and day == 7:
        event_number = 5
    elif month == 6 and day == 1 and year == 2023:
        event_number = 6
    elif month == 9 and day == 20 and year == 2023:
        event_number = 7
    elif harvest_eligible and randf() < EVENT_RATE * days_since_event:
        var i = randi_range(0, len(harvests) - 1)
        event_number = harvests[i]
        harvests.remove_at(i)
        if len(harvests) == 0:
            harvests = OG_HARVESTS.duplicate()
    elif randf() < EVENT_RATE * days_since_event:
        var i = randi_range(0, len(randoms) - 1)
        event_number = randoms[i]
        randoms.remove_at(i)
        if len(randoms) == 0:
            randoms = OG_RANDOMS.duplicate()
    
    if event_number >= 0:
        display(articles[event_number][0], articles[event_number][1])
        return true
    return false
    

func display(flavor, effect):
    get_tree().paused = true
    visible = true
    display_time = Time.get_ticks_msec()
    FLAVOR_LABEL.text = flavor
    EFFECT_LABEL.text = "[i]" + effect


func _input(event):
    if visible and not get_tree().get_first_node_in_group("main").visible and not get_tree().get_first_node_in_group("space").visible and not get_tree().get_first_node_in_group("tutorial").visible and Input.is_action_just_pressed("continue") and display_time + delay < Time.get_ticks_msec():
        get_tree().paused = false
        visible = false
