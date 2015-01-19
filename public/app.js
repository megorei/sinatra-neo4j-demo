window.onload = function(){
    if(navigator.geolocation) navigator.geolocation.getCurrentPosition(handleGetCurrentPosition);
};

function handleGetCurrentPosition(location){
    window.latitude     = location.coords.latitude;
    window.longitude    = location.coords.longitude;
}

$(document).ready(function(){
    var adviseDrug = function(symptoms, age, allergies){
        $.getJSON('/drug', {"symptoms": symptoms, "allergies": allergies, age: age, latitude: window.latitude, longitude: window.longitude}).done(function(json){
            $(".suggestion .drugs").empty();
            $.each(json, function(key, value){
                $(".suggestion .drugs").append('<li class="list-group-item">' + value + '</li>');
            });
        });
    };

    var adviseDoctor = function(symptoms, age, allergies){
        $.getJSON('/doctor', {"symptoms": symptoms, "allergies": allergies, age: age, latitude: window.latitude, longitude: window.longitude}).done(function(json){
            $(".suggestion .doctors").empty();
            $.each(json, function(key, value){
                $(".suggestion .doctors").append('<li class="list-group-item"><span class="badge">' + value + ' km</span>' + key + '</li>');
            });
        });
    };

    var updateSuggestions = function(element){
        var advisor     = $(element).parents('.advisor');
        var symptoms    = advisor.find('.symptoms').val();
        var allergies   = advisor.find('.allergies').val();
        var age         = advisor.find('.age').val();
        adviseDrug(symptoms, age, allergies);
        adviseDoctor(symptoms, age, allergies);
    };

    var multiselectOptions = {
        numberDisplayed: 5,
        buttonWidth: '400px',
        onChange: function(option, checked, select) {
            updateSuggestions(option);
        }
    };

    $('.advisor select.symptoms').multiselect($.extend({}, multiselectOptions, {
        nonSelectedText: 'Select symptoms'
    }));

    $('.advisor select.allergies').multiselect($.extend({}, multiselectOptions, {
        nonSelectedText: 'Select allergies'
    }));

    $('.advisor input.age').blur(function(){
        updateSuggestions(this);
    });

    $('.advisor input.age').keypress(function(e) {
        if(e.which == 13) {
            updateSuggestions(this);
            e.preventDefault();
        }
    });
});