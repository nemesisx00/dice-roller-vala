project('diceroller', 'vala')

dependencies = [
	dependency('gee-0.8'),
	dependency('gtk4'),
]

sources = files(
	'src/main.vala',
	'src/dice.vala',
	'src/ui/app.vala',
	'src/ui/dice.vala',
	'src/ui/result.vala',
	'src/ui/window.vala',
)

executable('diceroller', sources, dependencies: dependencies)
