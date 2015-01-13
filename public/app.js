$(document).ready(function(){
    var updateSuggestion = function(target, json){
        target.empty();
        $.each(json, function(key, value){
            target.append('<li class="list-group-item">' + value + '</li>');
        });
    };

    var adviseDrug = function(symptoms, age, allergies){
        $.getJSON('/drug', {"symptoms": symptoms, "allergies": allergies, age: age}).done(function(json){
            updateSuggestion($(".suggestion .drugs"), json);
        });
    };

    var adviseDoctor = function(symptoms, age, allergies){
        $.getJSON('/doctor', {"symptoms": symptoms, "allergies": allergies, age: age}).done(function(json){
            updateSuggestion($(".suggestion .doctors"), json);
        });
    };

    var updateSuggestions = function(element){
        var symptoms    = $(element).parents('.advisor').find('.symptoms').val();
        var allergies   = $(element).parents('.advisor').find('.allergies').val();
        var age         = $(element).parents('.advisor').find('.age').val();
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