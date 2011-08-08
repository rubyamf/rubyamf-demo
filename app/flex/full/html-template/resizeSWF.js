function getWidth() {
    
     if (document.getElementById('index').width != null)
     {
        return document.getElementById('index').width;
     }
     
     return document.getElementById('indexIE').width;   
}

function getHeight() {
    
     if (document.getElementById('index').height != null)
     {
        return document.getElementById('index').height;
     }
     
     return document.getElementById('indexIE').height;   
}

function setMinWidth(value) {
    
     document.getElementById('index').style.minWidth = value;
     
     if (document.getElementById('index').style.minWidth == 0 && value != 0)
     {
        //Try adding "px"
        document.getElementById('index').style.minWidth = value + "px";
     }
     
     document.getElementById('indexIE').style.minWidth = value;
     if (document.getElementById('indexIE').style.minWidth == 0 && value != 0)
     {
        //Try adding "px"
        document.getElementById('indexIE').style.minWidth = value + "px";
     }
     
}

function setMinHeight(value) {
    
    document.getElementById('index').style.minHeight = value;
    if (document.getElementById('index').style.minHeight == 0 && value != 0)
    {
        //Try adding "px"
        document.getElementById('index').style.minHeight = value + "px";
    }
     
    document.getElementById('indexIE').style.minHeight = value;
    if (document.getElementById('indexE').style.minHeight == 0 && value != 0)
    {
        //Try adding "px"
        document.getElementById('indexIE').style.minHeight = value + "px";
    }
}

