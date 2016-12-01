

class SurveyController < ApplicationController
  def action_allowed?
    ['Instructor',
     'Teaching Assistant',
     'Administrator'].include? current_role_name
  end
  #E1680. Improve survey functionality commit by dssathe
  @assignment
  def assign
    @assignment = Assignment.find(params[:id])
    #Dummy row created which will be selected by default
    @first_row=Questionnaire.new;
    @first_row.name="Select a Global Survey";
    @first_row.id=0;
    @my_surveys=Questionnaire.where(["instructor_id=? and type = 'SurveyQuestionnaire'", session[:user].id]);
    @global_surveys = Questionnaire.where(["type = 'GlobalSurveyQuestionnaire'"]);
    # Currently last row in the collection but should be selected by default.
    @global_surveys<<@first_row
  end
  
  def assign_survey
     assignment_id = params[:assignment_id]
    # get the survey id from select tag
    selected_survey_id = params[:my_survey]
    # get the questionnaire object from the id
    @selected_survey_questionnaire = Questionnaire.find(selected_survey_id)
    
    #create an entry for the questionnaire in assignment queationnaire table
    @new = AssignmentQuestionnaire.new(questionnaire_id: selected_survey_id, assignment_id: assignment_id, user_id: session[:user].id)
    @new.save
    
    # redirect back to the same page with same assignment id
    redirect_to action: "assign", id: assignment_id
    
  end
end
