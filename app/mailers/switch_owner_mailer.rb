class SwitchOwnerMailer < ApplicationMailer
  default from: 'from@example.com'

   def switch_owner_mail(team)
    @team = team
    mail to: @team.owner.email, subject: 'オーナー権限を付与'
  end
end
