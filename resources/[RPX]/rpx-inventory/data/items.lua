return {
    ['money'] = {
		label = 'Money',
	},

	['water'] = {
		label = 'Water',
		weight = 350,
		stack = true,
		close = true,
		description = "One hydrogen molecule, two oxygen",
		client = {
			status = { thirst = 10 },
			anim = 'drinking',
			prop = 'bottle',
			usetime = 5000,
		},
	},

	['bread'] = {
		label = 'Bread',
		weight = 350,
		stack = true,
		close = true,
		description = "Some delicious fresh bread",
		client = {
			status = { hunger = 10 },
			anim = 'eating',
			prop = 'bread',
			usetime = 5000,
		},
	},

	-- GOLD PANNING SYSTEM
	['goldpan'] = {
		label = 'Gold Pan',
		weight = 350,
		stack = false,
		close = true,
		description = "A gold pan to find precious gold",
	},
	['goldnugget'] = {
		label = 'Gold Nugget',
		weight = 10,
		stack = true,
		close = true,
		description = "A gold nugget, could be worth something!",
	},

	-- CAMPS SYSTEM
	['campkit'] = {
		label = 'Camp Kit',
		weight = 3500,
		stack = false,
		close = true,
		description = "A kit to set up a camp",
		image = "kit_upgrade_camp.png",
	},
	['campsupplies'] = {
		label = 'Camp Supplies',
		weight = 300,
		stack = true,
		close = true,
		description = "Some camp supplies to maintain a camp",
		image = "camp_supply.png",
	},

}