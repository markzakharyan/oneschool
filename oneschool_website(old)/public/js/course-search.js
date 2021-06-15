var rememberedChecks = []
let knownQueries = ["English 1", "English 1 Honors", "English 2", "English 2 Honors", "English 3", "ERWC 3 ?", "AP English Language", "ERWC 4 ?", "AP English Literature", "Beginning Journalism", "Advanced Journalism", "Creative Writing Fall", "Creative Writing Spring", "Graphic Novel Fall", "Graphic Novel Spring", "Science Fiction Literature Fall", "Science Fiction Literature Spring", "Marginalized and Misrepresented Fall", "Marginalized and Misrepresented Spring", "Math 1 AB", "Math 1", "Math 2", "Math Lab", "Enhanced Math 2", "Math 3", "Enhanced Math 3", "Pre-Calculus", "Fnct/Stat/Trig ?", "Statistics", "AP Statistics", "AP Calculus AB", "AP Calculus BC", "App Development", "Business Math", "College Math Prep", "AP Computer Science A", "AP Computer Science Principles", "Next Gen Biology", "Next Gen Biology Honors", "AP Biology", "NextGen Chemistry", "NextGen Chemistry Honors", "AP Chemistry", "NextGen Physics", "AP Physics 1/2", "AP Environmental Science", "Anatomy/Physiology A Fall", "Anatomy/Physiology A Spring", "Marine Science Fall", "Marine Science Spring", "English Language Development 1", "English Language Development 2", "ELD English 1", "ELD English 2", "ELD Social Science", "ELD Science", "CP English 1 A", "CP English 2 A", "Next Gen Biology 1 A", "NextGen Chem 1 A", "CP Global Perspectives A", "CP US History A", "Global Perspectives", "Global Perspectives Honors", "US History", "US History Honors", "AP US History", "Political Science Fall", "Political Science Spring", "AP Political Science Fall", "AP Political Science Spring", "Economics Fall", "Economics Spring", "AP Economics Fall", "AP Economics Spring", "American Experience Fall", "American Experience Spring", "Ethnic Studies Fall", "Ethnic Studies Spring", "Psychology Fall", "Psychology Spring", "AP Physcology", "World History", "AP World History", "AP Human Geography", "French 1", "French 2", "French 3", "French 4", "Latin 1", "Latin 2", "Latin 3", "Latin 4", "AP Latin", "Spanish 1", "Spanish 2", "Spanish 3", "Spanish 4", "Spanish (Native)", "AP Spanish Language", "AP Spanish Literature", "Chinese 1", "Chinese 2", "Chinese 3", "Chinese 4", "AP Chinese Language", "American Sign Language 1", "American Sign Language 2", "AP Music Theory", "Music Tech", "Dance Tech 1A", "Dance Tech 2A", "Dance Production", "String Orchestra", "Concert Orchestra", "Philharmonic Orchestra", "Symphonic Orchestra", "Guitar Studio", "Choir", "Canta Bella", "Madrigal Singers", "Drama 1A", "Drama 2A", "Advanced Drama", "Tech Theatre", "Advanced Tech Theatre", "Advanced Theatre Production A Fall", "Advanced Theatre Production B Spring", "Concert Band", "Symphonic Band", "Wind Symphony", "Wind Ensemble", "Jazz Ensemble Spring", "Marching Band", "Art Studio", "Intermidate Art Studio", "Advanced Art Studio", "AP Studio Art", "Graphic Design", "Advanced Graph Design", "AP 2D Design", "AP Art History", "Beginning Ceramics", "Intermediate Ceramics", "Advanced Ceramics", "Visual Imagery", "Advanced Visual Imagery", "Video Production", "Advanced Video Production", "Photojournalism", "Auto MLR 1", "Auto MLR 2", "Virtual Enterprise", "Intro Engineering", "Principles of Engineering", "Advanced Engineering", "PE 1 Fall", "PE 1 Spring", "PE 2 Fall", "PE 2 Spring", "Color Guard", "Pep Squad", "Competative Cheer", "Baseball", "Boys Basketball", "Girls Basketball", "Cross Country", "Football", "Boys Golf", "Girls Golf", "Boys Lacrosse", "Girls Lacrosse", "Boys Soccer", "Girls Soccer", "Softball", "Boys Swimming", "Girls Swimming", "Boys Tennis", "Girls Tennis", "Track", "Boys Volleyball", "Girls Volleyball", "Boys Water Polo", "Girls Water Polo", "Wrestling", "PE Private Inst ?", "Off Season Qtr 1", "Off Season Qtr 2", "Off Season Qtr 3", "Off Season Qtr 4", "Health Fall", "Health Spring", "Study Skills Fall", "Study Skills Spring", "Leadership", "ROP Class Fall", "ROP Class Spring", "Coll Class Fall ?", "Coll Class Spring ?", "Online Health Fall", "Online Health Spring", "Online Political Science Fall", "Online Political Science Spring", "Online Economics Fall", "Online Economics Spring", "Online PE", "Online Graphic Design", "Online Generic", "IEP Goals Report", "Dir Learning Str 1", "Dir Learning Str 2", "Dir Learning Str 3", "Dir Learning Str 4", "Dir English 2", "Dir English 3", "Dir English 4", "Practical English", "Pract Cons English", "Practical Math", "Pract Cons Math", "Life Skills", "Func Communications Skills", "Functional English", "Functional Math", "Functional Life Skills", "Functional Vocational Skills", "DHH Program", "DHH Lab", "DHH Dir English 1A", "DHH Dir English 2A", "DHH Dir English 3A", "DHH Dir Reading 1A", "DHH Dir Reading 2A", "DHH Dir Reading 3A", "DHH Dir Math A", "DHH App Math A", "DHH CBI Math A", "DHH Pre Math 1A", "DHH Math 1 CD", "DHH Math 1 A", "DHH Math 2 A", "DHH Math 3 A", "DHH Dir Intermediate Algebra A", "DHH Dir ESS", "DHH Dir Biology A", "DHH Dir Global Perspectives A", "DHH Dir US History A", "DHH Dir Economics", "DHH Political Science", "DHH Speech & Lang", "DHH CBI SS/Sci A"]

let possibleCoursesList = document.getElementById("checklist");


if (typeof String.prototype.startsWith != 'function') {
    // startWith checks if the string begins with the string passed in
    String.prototype.startsWith = function (str) {
        return this.slice(0, str.length) == str;
    };
}

angular.module('SuggestedQuery', [])
    .controller('suggestionInputCtrl', ['$scope', function ($scope) {
        // unknownQuery set to true during the first loop where no known queries are found, reset when newQuery is older than oldQuery
        var unknownQuery = false;
        var remainingKnown = function (newQuery) {
            for (var i = 0, x = knownQueries.length; i < x; i++) {
                if (knownQueries[i].toLowerCase().startsWith(newQuery.toLowerCase())) {
                    return knownQueries[i].substring(newQuery.length);
                }
            }
            unknownQuery = true;
            return '';
        };
        $scope.inputQuery = '';
        $scope.$watch(function () {
            return $scope.inputQuery;
        }, function (newQuery, oldQuery) {
            if (newQuery.length < oldQuery.length) {
                unknownQuery = false;
            }

            if (newQuery.length > 0) {
                if (!unknownQuery) {
                    if (remainingKnown(newQuery).substring(0, 24 - $scope.inputQuery.length) === remainingKnown(newQuery)) {
                        $scope.suggestedQuery = remainingKnown(newQuery);
                    }
                    else {
                        $scope.suggestedQuery = remainingKnown(newQuery).substring(0, 24 - $scope.inputQuery.length) + "...";
                    }

                    $scope.actualQuery = $scope.inputQuery + remainingKnown(newQuery);
                    console.log($scope.suggestedQuery);
                    console.log("ACTUAL QUERY: " + $scope.actualQuery);

                    //TODO: MAKE SEARCHING ALGORITHM SEXY
                    var possibleCourses = []
                    $scope.possibleCourses = possibleCourses
                    for (var i = 0, x = knownQueries.length; i < x; i++) {
                        var j = knownQueries[i];
                        if (j.toLowerCase().indexOf($scope.inputQuery.toLowerCase()) !== -1) {
                            possibleCourses.push(j)
                            console.log("PUSHED " + j)
                        }
                    }
                    console.log(possibleCourses)

                    var checkedItems = document.getElementsByClassName("courseSelection");
                    for (var i = 0, x = checkedItems.length; i < x; i++) {
                        if (checkedItems[i].checked) {
                            for (var e of document.getElementsByClassName("label-selection")) {
                                if (e.id === checkedItems[i].id) { console.log(e.innerHTML); var checkedText = e.innerHTML; rememberedChecks.push([checkedText, e.id]) }
                            }
                            console.log(rememberedChecks);


                        }
                    }
                    possibleCoursesList.innerHTML = '';
                    rememberedChecks.forEach((item) => {
                        var checkedItemId = item[1];
                        var checkedText = item[0]


                        possibleCoursesList.innerHTML += '<input type="checkbox" name="r" class="courseSelection" checked id="checked-item-' + checkedItemId + '" onclick="rememberedChecks.splice(rememberedChecks.indexOf([\'' + checkedText + '\',' + checkedItemId + ']),1);console.log(rememberedChecks)"><label id="checked-item-' + checkedItemId + '" for="checked-item-' + checkedItemId + '">' + checkedText + '</label>';

                        console.log(rememberedChecks)
                    });

                    //possibleCoursesList.innerHTML = '';

                    //possibleCoursesList.innerHTML = '<input type="checkbox" name="r" class="courseSelection" checked id="checked-item-' + checkedItemId + '" onclick="rememberedChecks.splice(rememberedChecks.indexOf([\'' + checkedText + '\',' + checkedItemId + ']),1);console.log(rememberedChecks)"><label for="checked-item-' + checkedItemId + '">' + checkedText + '</label>';// + possibleCoursesList.innerHTML


                    possibleCourses.forEach((item, index) => {
                        if (possibleCoursesList.getElementsByTagName("input").length < 8) {
                            let input = document.createElement("input");

                            input.type = "checkbox";
                            input.name = "r";
                            input.className = "courseSelection";
                            input.id = index;

                            let label = document.createElement("label");
                            label.innerText = item;
                            label.className = "label-selection"
                            label.setAttribute("for", index);
                            label.id = index
                            possibleCoursesList.appendChild(input);
                            possibleCoursesList.appendChild(label);

                        }

                    })
                }
            } else {
                $scope.suggestedQuery = 'Search for classes';
            }

        }, false);
        $scope.editInput = function () {
            $scope.$broadcast('editQuery');

        };



    }])
    .directive('contenteditable', function () {
        return {
            restrict: 'A',
            link: function (scope, element, attrs) {

                var read = function () {
                    // TODO: reads the element html, then sets the value to inputQuery
                    scope.inputQuery = element.html();
                };
                var clearSuggestion = function () {
                    scope.suggestedQuery = scope.suggestedQuery.substring(1);
                    //         scope.suggestedQuery = '';
                };

                element.bind('blur keyup change', function (e) {
                    if (e.keyCode == 39) {
                        // if you click right arrow (tab doesnt work cuz accesibility shit), it fills the rest with the suggested query
                        scope.inputQuery += scope.suggestedQuery;
                        element.html(scope.inputQuery);
                        scope.suggestedQuery = '';
                    } else {
                        read();
                    }
                    scope.$apply();
                });
                element.bind('blur', function () {
                    scope.$apply(function () {
                        scope.isFocused = false;
                    });
                });
                element.bind('keydown', function (e) {

                    if (e.keyCode == 13) {
                        // prevent default enter button
                        e.preventDefault();
                        return;
                    } else if (!/[a-zA-Z0-9-_ ]/.test(String.fromCharCode(e.keyCode))) {
                        // makes sure query is alphanumeric with sexy regex

                    } else {
                        scope.$apply(clearSuggestion);
                    }
                });
                scope.$on('editQuery', function () {
                    element[0].focus();
                });

            }
        }
    });




function getSelectedCourses() {
    selectedCourses = [];
    for (var i = 0, x = rememberedChecks.length; i < x; i++) {
        selectedCourses.push(rememberedChecks[i][0]);
    }

    var checkedItems = document.getElementsByClassName("courseSelection");
    for (var i = 0, x = checkedItems.length; i < x; i++) {
        if (checkedItems[i].checked) {
            for (var e of document.getElementsByClassName("label-selection")) {
                if (e.id == checkedItems[i].id) { selectedCourses.push(e.innerText) }
            }



        }
    }
    console.log(selectedCourses);
    //all classes selected by user ^
    return getSelectedCourses;
}