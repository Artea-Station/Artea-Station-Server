/datum/job/tradership_captain
	title = "Ship Captain"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD|DEADMIN_POSITION_SECURITY
	department_head = list("Free Trade Union")
	faction = "Tradership"
	total_positions = 1
	spawn_positions = 1
	supervisors = "your profit margin, your conscience, and the Trademaster"
	selection_color = "#ccccff"
	req_admin_notify = 1
	minimal_player_age = 14
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_COMMAND

	outfit = /datum/outfit/job/captain
	plasmaman_outfit = /datum/outfit/plasmaman/captain

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_CAPTAIN
	departments_list = list(/datum/job_department/command)

/datum/job/tradership_first_mate
	title = "First Mate"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	head_announce = list(RADIO_CHANNEL_SUPPLY, RADIO_CHANNEL_SERVICE)
	department_head = list("Free Trade Union")
	faction = "Tradership"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#ddddff"
	req_admin_notify = 1
	minimal_player_age = 10
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_SERVICE

	outfit = /datum/outfit/job/hop
	plasmaman_outfit = /datum/outfit/plasmaman/head_of_personnel
	departments_list = list(/datum/job_department/command)

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SRV
	bounty_types = CIV_JOB_RANDOM

	liver_traits = list(TRAIT_ROYAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_HEAD_OF_PERSONNEL

/datum/job/tradership_engineer
	title = "Ship Engineer"
	department_head = list("Captain")
	faction = "Tradership"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the First Mate and the Captain"
	selection_color = "#fff5cc"
	exp_requirements = 60
	exp_required_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/engineer
	plasmaman_outfit = /datum/outfit/plasmaman/engineering

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_ENG

	liver_traits = list(TRAIT_ENGINEER_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_STATION_ENGINEER
	bounty_types = CIV_JOB_ENG
	departments_list = list(/datum/job_department/engineering)

/datum/job/tradership_doctor
	title = "Ship Doctor"
	department_head = list("Captain")
	faction = "Tradership"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the First Mate and the Captain"
	selection_color = "#ffeef0"

	outfit = /datum/outfit/job/doctor
	plasmaman_outfit = /datum/outfit/plasmaman/medical

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_MED

	liver_traits = list(TRAIT_MEDICAL_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_MEDICAL_DOCTOR
	bounty_types = CIV_JOB_MED
	departments_list = list(/datum/job_department/medical)

/datum/job/tradership_researcher
	title = "Researcher"
	department_head = list("Captain")
	faction = "Tradership"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the First Mate and the Captain"
	selection_color = "#ffeeff"
	exp_requirements = 60
	exp_required_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/scientist
	plasmaman_outfit = /datum/outfit/plasmaman/science

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SCI

	display_order = JOB_DISPLAY_ORDER_SCIENTIST
	bounty_types = CIV_JOB_SCI
	departments_list = list(/datum/job_department/science)

/datum/job/tradership_deckhand
	title = "Deckhand"
	department_head = list("Captain")
	faction = "Tradership"
	total_positions = 50
	spawn_positions = 20
	supervisors = "literally everyone, you bottom feeder"
	selection_color = "#dcba97"

	outfit = /datum/outfit/job/cargo_tech
	plasmaman_outfit = /datum/outfit/plasmaman/cargo

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_CAR
	display_order = JOB_DISPLAY_ORDER_CARGO_TECHNICIAN
	bounty_types = CIV_JOB_RANDOM
	departments_list = list(/datum/job_department/cargo)

/datum/job/tradership_cook
	title = "Ship Cook"
	department_head = list("Captain")
	faction = "Tradership"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the First Mate and the Captain"
	selection_color = "#bbe291"

	outfit = /datum/outfit/job/cook
	plasmaman_outfit = /datum/outfit/plasmaman/chef

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV

	liver_traits = list(TRAIT_CULINARY_METABOLISM)

	display_order = JOB_DISPLAY_ORDER_COOK
	bounty_types = CIV_JOB_CHEF
	departments_list = list(/datum/job_department/assistant)

/datum/job/tradership_botanist
	title = "Ship Botanist"
	department_head = list("Captain")
	faction = "Tradership"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the First Mate and the Captain"
	selection_color = "#bbe291"

	outfit = /datum/outfit/job/botanist
	plasmaman_outfit = /datum/outfit/plasmaman/botany

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV
	display_order = JOB_DISPLAY_ORDER_BOTANIST
	bounty_types = CIV_JOB_GROW
	departments_list = list(/datum/job_department/service)

/datum/job/tradership_stowaway
	title = "Stowaway"
	faction = "Tradership"
	total_positions = 1
	spawn_positions = 1
	supervisors = "your own interests"
	selection_color = "#dddddd"
	outfit = /datum/outfit/job/assistant
	plasmaman_outfit = /datum/outfit/plasmaman
	paycheck = PAYCHECK_LOWER
	departments_list = list(/datum/job_department/assistant)

	paycheck_department = ACCOUNT_CIV
	display_order = JOB_DISPLAY_ORDER_ASSISTANT

/datum/job/cyborg/tradership
	title = "Ship Cyborg"
	faction = "Tradership"
