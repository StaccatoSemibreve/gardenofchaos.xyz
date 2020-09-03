// "<div class=\"archive\" id=\"goc1\"><iframe width=\"100%\" height=\"100%\" src=\"https://www.youtube.com/embed/zlEVTEpSjqc\" frameborder=\"0\" allow=\"encrypted-media; picture-in-picture\" allowfullscreen class=\"video\"></iframe><iframe src=\"https://challonge.com/FSGardenofChaos1/module\" width=\"100%\" height=\"100%\" frameborder=\"0\" scrolling=\"auto\" allowtransparency=\"true\" class=\"bracket\"></iframe></div>"

function addArchive(element, id, videoURL, bracketURL) {
	archive = document.createElement("DIV");
	archive.setAttribute("class", "archive");
	archive.setAttribute("id", id);
	
	video = document.createElement("IFRAME");
	video.setAttribute("class", "video");
	video.setAttribute("src", videoURL);
	video.setAttribute("allow", "encrypted-media; picture-in-picture; fullscreen");
	
	bracket = document.createElement("IFRAME");
	bracket.setAttribute("class", "bracket");
	bracket.setAttribute("src", bracketURL);
	bracket.setAttribute("scrolling", "auto");
	bracket.setAttribute("allowtransparency", "true");
	
	archive.appendChild(video);
	archive.appendChild(bracket);
	element.parentNode.appendChild(archive);
	
	element.setAttribute("onclick", 'removeArchive(this, "'+id+'", "'+videoURL+'", "'+bracketURL+'")');
	element.innerHTML="Stop Watching Archive (will unload the external content!)";
}

function removeArchive(element, id, videoURL, bracketURL) {
	document.getElementById(id).outerHTML="";
	element.setAttribute("onclick", 'addArchive(this, "'+id+'", "'+videoURL+'", "'+bracketURL+'")');
	element.innerHTML="Watch Archive (will load external content from YouTube and Challonge!)";
}
