		var seed = 43568;
		var i = 0;
		var teams = [["Grave", "Jaina", "Argagarg"],["DeGrey", "Quince", "Rook", "Lum", "Setsuki", "Quince", "Rook", "Lum", "Setsuki", "Quince", "Rook", "Lum"]];

		//TODO: read url parameters here



		teams.forEach(function(chars, team) {
		chars.forEach(function(char, index) {
			charIcon = document.getElementById(char.toLowerCase()).cloneNode();
			charIcon.setAttribute("style", "width:100px; height:100px;");
			charIcon.setAttribute("id", `team${team+1}member${index}`);
			document.getElementById(`team${team+1}`).appendChild(charIcon);
		});
		});


		function seededRandom(min, max) {
		max = max || 1;
		min = min || 0;

		seed = (seed * 9301 + 49297) % 233280;
		var rnd = seed / 233280;

		return min + rnd * (max - min);
		}

		function start() {
		picks = teams.map(team => Math.floor(seededRandom(0,team.length)));
		chars = teams.map((team, i) => team[picks[i]]);
		console.log(chars);
		}
