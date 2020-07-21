// vim keys
function _pageScroll() {
    // Gecko algorithm
    // ----------------
    // The page increment is the size of the page, minus the smaller of
    // 10% of the size or 2 lines.
    return window.innerHeight - Math.min(window.innerHeight / 10, 24);
}

function up() {
    if (window.scrollByLines)
	window.scrollByLines(-1); // gecko
    else
	window.scrollBy(0, -12); // webkit
}

function down() {
    if (window.scrollByLines)
	window.scrollByLines(1); // gecko
    else
	window.scrollBy(0, 12); // webkit
}

function pageup() {
    if (window.scrollByPages)
	window.scrollByPages(-1); // gecko
    else
	window.scrollBy(0, 0 - _pageScroll()); // webkit
}

function pagedown() {
    if (window.scrollByPages)
	window.scrollByPages(1); // gecko
    else
	window.scrollBy(0, _pageScroll()); // webkit
}

function right() {
    window.scrollBy(15, 0);
}

function left() {
    window.scrollBy(-15, 0);
}

function home() {
    window.scroll(0, 0);
}

function bottom() {
    window.scroll(document.width, document.height);
}

// easy links for surf
// config , any css
var openkey     = 'Enter'
var label_style = {"color":"black","fontSize":"10px","backgroundColor":"#27FF27","fontWeight":"normal","margin":"0px","padding":"0px","position":"absolute","zIndex":99};
var hl_style    = {"backgroundColor":"#E3FF38","fontSize":"15px"};
var nr_base     = 5;   // >=10 : normal integer,

// globals
var ankers     = document.body.querySelectorAll('a, input:not([type=hidden]), textarea, select, button');
var labels     = new Object();
var ui_visible = false;
var input      = "";

// functions
function hl(t) {
	for(var id in labels) {
		if (t && id.match("^"+t)==t)
			for(var s in hl_style)
				labels[id].rep.style[s]=hl_style[s];
		else
			for(var s in label_style)
				labels[id].rep.style[s]=label_style[s];
	}
}

function open_link(id) {
	try {
		var a = labels[input].a;
		if(a) window.location.href=a.href;
	} catch (e) {}
}

function set_ui(s) {
	var pos = "static";
	ui_visible = true;
	if(s == "hidden") {
		ui_visible = false;
		pos = "absolute";
		input="";
	}
	for(var id in labels) {
		labels[id].rep.style.visibility=s;
		labels[id].rep.style.position=pos;
	}
}

function base(n, b) {
	if(b>=10) return n.toString();
	var res = new Array();
	while(n) {
		res.push( (n%b +1).toString() )
		n=parseInt(n/b);
	}
	return res.reverse().join("");
}

var hintalphabet = '12345';
function hints() {
	window.removeEventListener('keydown', keydown, false);

	// set key handler
	set_ui("visible");
	window.addEventListener('keydown', keyhandler, false);
	function keyhandler(e) {
		if(e.key == openkey) {
			open_link(input);
			set_ui("hidden");
		} else if (hintalphabet.indexOf(e.key) >= 0) {
			input += e.key;
			hl(input);
		} else {
			input="";
			set_ui("hidden");
			hl(input);
			window.removeEventListener('keydown', keyhandler, false);
			window.addEventListener('keydown', keydown, false);
		}
	}

}

function run() {
	// main
	// create labels
	for (var i=0; i<ankers.length; i++) {
		var a = ankers[i];
		if (!a.href) continue;
		var b = base(i+1,nr_base);
		var d = document.createElement("span");
		d.style.visibility="hidden";
		d.innerHTML=b;
		for(var s in label_style)
			d.style[s]=label_style[s];
		labels[b]={"a":a, "rep":d};
		a.parentNode.insertBefore(d, a.nextSibling);
	}
}

testcomplete = function() {
	if(document.readyState=="complete") {
		run(); return;
	}
	window.setTimeout("testcomplete()",200);
}
testcomplete();

// If you don't like default key bindings, customize here.
// if you want to use the combination 'Ctrl + b' (for example), use '^b'
var bindings = {
    'h' : left,
    'l' : right,
    'k' : up,
    'j' : down,
    'g' : home,
    'G' : bottom,
	'f' : hints,
}

function isEditable(element) {

    if (element.nodeName.toLowerCase() == 'textarea')
	return true;
    // we don't get keypress events for text input, but I don't known
    // if it's a bug, so let's test that
    if (element.nodeName.toLowerCase() == 'input' && element.type == 'text')
	return true;
    // element is editable
    if (document.designMode == 'on' || element.contentEditable == 'true') {
	return true;
    }

    return false;
}

function keydown(evt) {
    var target = evt.target;

    // if we're on a editable element, we probably don't want to catch
    // keypress, we just want to write the typed character.
    if (isEditable(target))
	return;
    var key = evt.key;
    if (evt.ctrlKey) {
	key = '^' + key;
    }
    var fun = bindings[key];
    if (fun)
	fun();
}

window.addEventListener('keydown', keydown, false);
