(function(angular, app) {
    "use strict";
    app.controller("SalaryBreakUpsController",["$scope", "$http", function($scope, $http) {
        $scope.initialize = function(type){
            $scope.editable = false;
            $http.get("/salary_break_ups.json?type="+type)
                .then(function(response){
                    $scope.salary_break_ups = response.data
                })
        }

        $scope.update = function(){
            $http.put("/salary_break_ups/update_all.json", {salary_break_ups: $scope.salary_break_ups})
                .then(function(response){
                    if(response.status){
                        $scope.editable = false
                    }
                })
        };
        
        
    }]);

    app.controller("SalaryBreakUpInitializeController",["$scope", "$compile", "$element", function($scope, $compile, $element) {
        $scope.isClicked = false
        $scope.generate_salary_break_up = function(ctc, basic, probation_date, designation){
            $scope.isClicked = true
            if(typeof designation == 'undefined'){
                designation = "\""+$("#designation_name").val()+"\""
            }
            var directive_to_add = $compile("<salary-break-up ctc='"+ctc+"', basic='"+basic+"', probation_date= '\""+probation_date+"\"', designation= '"+designation+"'></salary-break-up>")($scope);
            angular.element(document.getElementById('salaryBreakUpShowDiv')).html(directive_to_add);
        }

    }]);
})(angular, payRollApp);
