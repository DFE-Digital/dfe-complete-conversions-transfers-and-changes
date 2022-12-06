class Conversion::Voluntary::TaskList::SupplementalFundingAgreementsController < Conversion::Voluntary::TaskList::BaseTasksController
  def edit
    @project = Project.find(params[:project_id])

    @supplemental_funding_agreement = Conversion::Voluntary::TaskList.find_by(project: @project).supplemental_funding_agreement
    # @tasks = Conversion::Voluntary::TaskList.find_by(project: @project).tasks
  end

  def update
    @supplemental_funding_agreement = Conversion::Voluntary::SupplementalFundingAgreement.new(supplemental_funding_agreement_params)
    @project = Project.find(params[:project_id])
    @task_list = Conversion::Voluntary::TaskList.find_by(project: @project)

    if @supplemental_funding_agreement.valid?
      @task_list.update!(supplemental_funding_agreement: @supplemental_funding_agreement)

      redirect_to project_path(@project)
    else
      render :edit
    end
  end

  private

  def supplemental_funding_agreement_params
    params.require(:conversion_voluntary_supplemental_funding_agreement).permit \
      :received, :cleared, :signed_by_school, :saved_in_school_sharepoint, :sent_to_team_leader, :document_signed
  end
end
