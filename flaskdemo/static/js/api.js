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
    if (isEmpty(input0)) {
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
    document.getElementById("where1").innerHTML = "Code: " + input0
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
