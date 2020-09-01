        var teams = [[],[]];
        var i = 0;

        function createCharElement(charName, teamNumber) {
            i++;
            
            div = document.createElement("DIV");
            div.setAttribute("id",i+"char");
            div.setAttribute("class","icon;");
            
            clicker = document.createElement("A");
            clicker.setAttribute("href", "javascript:void(0);");
            clicker.setAttribute("title", "Remove this "+charName+" from Team "+teamNumber+".");
            clicker.setAttribute("onclick", 'removeChar("'+i+'char", '+teamNumber+')');
            clicker.setAttribute("id", i+"char");
            div.appendChild(clicker);
            clicker.appendChild(document.getElementById(charName.toLowerCase()).cloneNode());
            clicker.appendChild(document.getElementById("minus").cloneNode());
            
            return div;
        }
        function addChar(char, teamNumber) {
            console.log("Add "+char+" to team "+teamNumber+".");
            teams[teamNumber-1] = teams[teamNumber-1].concat(char);
            
            document.getElementById('team'+teamNumber+'div')
                    .appendChild(createCharElement(char, 1));
            
            if(teams[0].length > 0 && teams[1].length > 0)
                document.getElementById("submitlink").href = "https://gardenofchaos.xyz/teamdisplay?seed=" + (10000+Math.floor(Math.random()*90000)) + "&team1="+teams[0].join() + "&team2="+teams[1].join();
        }
        function removeChar(char, teamNumber) {
            console.log("Remove char "+char+" from team "+teamNumber+".");
            teams[teamNumber-1].splice(0+char.substr(0,1),1);
            document.getElementById(char).remove();
        }
        function clearTeam(teamNumber) {
			console.log("Clear team "+teamNumber+".");
			teams[teamNumber-1]=[];
			document.getElementById("team"+teamNumber+"div").innerHTML="";
        }
