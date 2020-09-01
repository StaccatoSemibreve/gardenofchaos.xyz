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
