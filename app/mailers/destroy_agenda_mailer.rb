class DestroyAgendaMailer < ApplicationMailer
  default from: 'from@example.com'

  def destroy_agenda_mail(agenda, member)
    @agenda = agenda
    mail to: member.email, subject: "アジェンダ「#{@agenda.title}」を削除しました。"
  end
end
