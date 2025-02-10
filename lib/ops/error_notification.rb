class Ops::ErrorNotification
  def initialize
    @notifier = Slack::Notifier.new(
      ENV.fetch("SLACK_EXCEPTION_NOTIFICATIONS_URL"),
      {
        channel: ENV.fetch("SLACK_EXCEPTION_NOTIFICATIONS_CHANNEL"),
        username: "error notifier"
      }
    )
  end

  def handled(message:, user:, path:)
    blocks = ExceptionNotifierConfig.blocks

    secondary_blocks = [{
      type: "section",
      text: {
        type: "mrkdwn",
        text: "*#{message}*"
      },
      fields: [
        {
          type: "mrkdwn",
          text: "path `#{path}`"
        },
        {
          type: "mrkdwn",
          text: "user: `#{user}`"
        }
      ]
    }]

    @notifier.post(blocks: blocks, attachments: [{
      color: ExceptionNotifierConfig.color,
      blocks: secondary_blocks
    }])
  end
end
