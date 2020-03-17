class AgendasController < ApplicationController
  # before_action :set_agenda, only: %i[show edit update destroy]
  before_action :set_agenda, only: [:destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda')
    else
      render :new
    end
  end

#アジェンダの削除機能を追記
  def destroy
    if @agenda.team.owner_id == current_user.id || @agenda.user_id == current_user.id
      @agenda.team.members.each do |member|
        DestroyAgendaMailer.destroy_agenda_mail(@agenda, member).deliver
      end
      @agenda.destroy
        redirect_to dashboard_url, notice: "アジェンダ「#{@agenda}」を削除しました。"
      else
        redirect_to :back, notice: "アジェンダ「#{@agenda}」の削除に失敗しました。"
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
