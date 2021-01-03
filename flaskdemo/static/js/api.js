// javascript functions

// white-dark mode
function whitedark() {
  var element = document.body;
  element.classList.toggle("dark-mode");
}


// return key input
function keyf()
{
    var input0 = document.getElementById("key0").value;
    // !textVal.match(/\S/)
    // isEmpty(input0)
    if (!input0.match(/\S/)) {
      document.getElementById("key1").innerHTML = "Please input an API key!";
      document.getElementById("key1").style.color = "red";
    } else {
      document.getElementById("key1").innerHTML = "Key: " + input0
      document.getElementById("key1").style.color = "green";
    }
}


// return country code input
function wheref()
{
    var input0 = document.getElementById("where0").value;
    if (!input0.match(/\S/)) {
      document.getElementById("where1").innerHTML = "Please input a country code!";
      document.getElementById("where1").style.color = "red";
    } else {
      document.getElementById("where1").innerHTML = "Code: " + input0
      document.getElementById("where1").style.color = "green";
    }
}


// start time
function sday()
{
    var input0 = document.getElementById("start0").value;
    var reg = /^\d{4}-\d{2}-\d{2}$/;
    if (reg.test(input0)){
        document.getElementById("start1").innerHTML = "Valid Input";
        document.getElementById("start1").style.color = "green";
    }
    else{
        document.getElementById("start1").innerHTML = "Please input according to the format: yyyy-mm-dd";
        document.getElementById("start1").style.color = "red";
    }
}


// end time
function eday()
{
    var input0 = document.getElementById("end0").value;
    var reg = /^\d{4}-\d{2}-\d{2}$/;
    if (reg.test(input0)){
        document.getElementById("end1").innerHTML = "Valid Input";
        document.getElementById("end1").style.color = "green";
    }
    else{
        document.getElementById("end1").innerHTML = "Please input according to the format: yyyy-mm-dd";
        document.getElementById("end1").style.color = "red";
    }
}


// API choice of image
function itype()
{
    var input0 = document.getElementById("plt0").value;
    document.getElementById("plt1").innerHTML = "Selected " + input0
}


// check if all options are filled
function query0()
{
    // https://stackoverflow.com/questions/15953988/preventing-form-submission-when-input-field-is-empty
    var vkey = document.getElementById("key1").style.color;
    var vwhere = document.getElementById("where1").style.color;
    var vstart = document.getElementById("start1").style.color;
    var vend = document.getElementById("end1").style.color;

    if ((vkey === "red") || (vwhere === "red") || (vstart === "red") || (vend === "red")) {
        alert("Please fill in all fields or keep the default values!");
        return false;
    }
}


// make default image disappear
function vanish(){
    // https://stackoverflow.com/questions/996633/how-to-create-a-hidden-img-in-javascript
    // https://stackoverflow.com/questions/53587115/hide-show-form-on-button-click-in-flask
    // im0 = document.getElementById('image2');
    // https://www.w3schools.com/howto/howto_js_check_hidden.asp
    var dis0 = document.getElementById("image2");

    if(window.getComputedStyle(dis0).display === "none"){
      document.getElementById("image2").style.display = "inline-block";
    } else{
      document.getElementById("image2").style.display = "none";
    }
}
