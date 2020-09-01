        var formats = [
            'Deck',
            'Choose Your Enemy, aka Cursed, aka Vice Versus',
            'Roll the Dice',
            'Democracy',
            'Mirror Mayhem',
            'The Many and the Few',
            'Simplify',
            'Lawful',
            'Chaotic',
            'Teams',
            'Play Fair',
            'You Are What You Beat',
            'Your Own Worst Enemy',
            'Best Three of Four',
            'BBBest Tournament'
        ];
        var characters = [
            'Grave',
            'Jaina',
            'Geiger',
            'Argagarg',
            'Setsuki',
            'Valerie',
            'Rook',
            'Midori',
            'Lum',
            'Degrey',
            'Quince',
            'Onimaru'
        ];
        var rulesets = [
            'Gravity',
            'Holly\'s Motherboard',
            'Jaywalking Is Illegal',
            'I Would Simply Press All the Best Buttons',
            'Play By Feel',
            'Aerial Assault',
            'Stop Spamming!!!',
            'Combo Disgust',
            'Lightweight Hitter',
            '1, 2, 3, Charge!',
            'I\'m Feeling Lucky!',
            'I Have the High Ground',
            'The Floor Is Lava',
            'Gauge Overcharge',
            'Not Even My Final Form',
            'No Longer My Final Form'
        ];
        var rulesetsMirrors = [
            'Mirror?',
            'T♯',
            'Rushdown',
            'YOLO',
            'Low Charge',
            'ArgagargGargArgagargGarg',
            'Divefish',
            'Godhand Fish Dive',
            'Galaxy Brain Ninja',
            'Out of Ink',
            'Free Hugs',
            'Midivekick',
            'Clash of the Items',
            'No U',
            'Undeadly Debate',
            'One Punch Lawyer'
        ];
        
        function generate() {
            var operator = document.getElementById("operator").value;
            var result = document.getElementById("result");
            var textArray;
            switch(operator) {
                case "Tournament Style":
                textArray = formats;
                break;
                case "Character":
                textArray = characters;
                break;
                case "Ruleset":
                textArray = rulesets;
                break;
                case "Ruleset (+ Mirrors)":
                textArray = rulesetsMirrors.concat(rulesets);
                break;
                default:
                textArray = ["uhhhh"];
            }
            var randomNumber = Math.floor(Math.random()*textArray.length);
            result.value = textArray[randomNumber];
        }
