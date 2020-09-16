function build
	echo "<!DOCTYPE html>
<html lang=\"\">
	<head>
		<meta charset=\"utf-8\">
		<title>$argv[2]</title>
		<link rel=\"icon\" type=\"image/png\" href=\"FSgardenOfChao-196x196.png\" sizes=\"196x196\">
		<link rel=\"stylesheet\" href=\"navbar-style.css\">"
	for i in $argv[3..-1]
		echo $i
	end
	echo "		<style>"
	cat $argv[1]/style.css
	echo "		</style>
	</head>
	<body>"
	cat navbar.html
	cat $argv[1]/main.html
	echo "		<footer></footer>
	</body>
	<script>"
	cat $argv[1]/script.js
	echo "	</script>
</html>"
end

function build-static
	echo "<!DOCTYPE html>
<html lang=\"\">
	<head>
		<meta charset=\"utf-8\">
		<title>$argv[2]</title>
		<link rel=\"icon\" type=\"image/png\" href=\"FSgardenOfChao-196x196.png\" sizes=\"196x196\">
		<link rel=\"stylesheet\" href=\"navbar-style.css\">
		<style>"
	cat $argv[1]/style.css
	echo "		</style>
	</head>
	<body>"
	cat navbar.html
	cat $argv[1]/main.html
	echo "		<footer></footer>
	</body>
</html>"
end

function build-markdown
	echo "<!DOCTYPE html>
<html lang=\"\">
	<head>
		<meta charset=\"utf-8\">
		<title>$argv[2]</title>
		<link rel=\"icon\" type=\"image/png\" href=\"FSgardenOfChao-196x196.png\" sizes=\"196x196\">
		<link rel=\"stylesheet\" href=\"markdown-style.css\">
		<link rel=\"stylesheet\" href=\"navbar-style.css\">
	</head>
	<body>"
	cat navbar.html
	echo "	    <main>
			<div id=\"center-div\">"
	markdown -f "toc" $argv[1].md | sed 's/^/\t\t\t\t/'
	echo "		</div>
    </main>
	<footer></footer>
	</body>
</html>"
end


build-markdown index "Garden of Chaos: Home"				> ../index.html
build-markdown rules "Garden of Chaos: Rules"				> ../rules.html
build-markdown styles "Garden of Chaos: Tournament Formats"	> ../styles.html
build-markdown rulesets "Garden of Chaos: Rulesets"			> ../rulesets.html
build-markdown resources "Garden of Chaos: Resources"		> ../resources.html
build-markdown commentators "Garden of Chaos: Commentators"	> ../commentators.html
build tournaments "Garden of Chaos: Tournament Archive"		> ../tournaments.html
build random "Garden of Chaos: Randomiser"					> ../random.html

build-markdown thoughts "Janet's Thoughts on Stuff™"				> ../thoughts.html
build-markdown thoughts-throws "Janet's Thoughts on Throws"			> ../thoughts-throws.html
build-markdown thoughts-dice "Janet's Thoughts on Dice"				> ../thoughts-dice.html
build-markdown thoughts-advantage "Janet's Thoughts on Advantage"	> ../thoughts-advantage.html
build-markdown thoughts-lumoki "Janet's Thoughts on Lum's Oki"		> ../thoughts-lumoki.html

build teams "Garden of Chaos: Team Battle Tool"						> ../teams.html
build teams2 "Garden of Chaos: Async Teams Tool"					> ../teams2.html
build teamsfancy "Garden of Chaos: Team Selector" (for i in "grave" "jaina" "geiger" "argagarg" "setsuki" "valerie" "rook" "midori" "lum" "degrey" "quince" "onimaru"; echo "		<link rel=\"preload\" href=\"media/$i.png\" as=\"image\" type=\"image/png\">"; end)	> ../teamsfancy.html
build teamdisplay "Garden of Chaos: Team Battle" (for i in "grave" "jaina" "geiger" "argagarg" "setsuki" "valerie" "rook" "midori" "lum" "degrey" "quince" "onimaru"; echo "		<link rel=\"preload\" href=\"media/$i.png\" as=\"image\" type=\"image/png\">"; end)	> ../teamdisplay.html
