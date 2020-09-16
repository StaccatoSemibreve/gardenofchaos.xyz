function build
	echo "<!DOCTYPE html>
<html lang=\"\">
	<head>"
	cat $argv[1]/head.html	
	echo "		<style>"
	cat $argv[1]/style.css
	cat navbar/style.css
	echo "		</style>
	</head>
	<body>"
	cat navbar/main.html
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
	<head>"
	cat $argv[1]/head.html	
	echo "		<style>"
	cat $argv[1]/style.css
	cat navbar/style.css
	echo "		</style>
	</head>
	<body>"
	cat navbar/main.html
	cat $argv[1]/main.html
	echo "		<footer></footer>
	</body>
</html>"
end

function build-markdown
	echo "<!DOCTYPE html>
<html lang=\"\">
	<head>"
	cat $argv[1]/head.html	
	echo "		<style>"
	cat $argv[1]/style.css
	cat navbar/style.css
	echo "		</style>
	</head>
	<body>"
	cat navbar/main.html
	echo "	    <main>
			<div id=\"center-div\">"
	markdown $argv[1]/main.md | sed 's/^/\t\t\t\t/'
	echo "		</div>
    </main>
	<footer></footer>
	</body>
</html>"
end


build-static index					> ../index.html
build-static rules					> ../rules.html
build-static styles					> ../styles.html
build-static rulesets				> ../rulesets.html
build-static resources				> ../resources.html
build-static commentators			> ../commentators.html
build tournaments					> ../tournaments.html
build tournaments-tpkweekly 		> ../tournaments-tpkweekly.html
build random						> ../random.html
build teams							> ../teams.html
build teams2						> ../teams2.html
build teamsfancy					> ../teamsfancy.html
build teamdisplay					> ../teamdisplay.html
build-markdown thoughts				> ../thoughts.html
build-markdown thoughts-throws		> ../thoughts-throws.html
build-markdown thoughts-dice		> ../thoughts-dice.html
build-markdown thoughts-advantage	> ../thoughts-advantage.html
build-static thoughts-lumoki		> ../thoughts-lumoki.html
