require "rails_helper"

RSpec.describe Ops::ErrorNotification do
  let(:slack_notifier) { instance_double(Slack::Notifier, post: true) }

  before do
    allow(Slack::Notifier).to receive(:new).and_return(slack_notifier)
  end

  describe "initialise" do
    it "sets up a Slack::Notifier" do
      Ops::ErrorNotification.new

      expect(Slack::Notifier).to have_received(:new).with(
        "SLACK_EXCEPTION_NOTIFICATIONS_URL",
        {
          channel: "SLACK_EXCEPTION_NOTIFICATIONS_CHANNEL",
          username: "error notifier"
        }
      )
    end
  end

  describe "#handled(message:, user:, path:)" do
    let(:message) { "An error was handled" }
    let(:user) { "roger@example.com" }
    let(:path) { "/path/to/resource" }

    let(:error_notification) { Ops::ErrorNotification.new }

    it "sets the color on the attachment, using ExceptionNotifierConfig" do
      error_notification.handled(message: message, user: user, path: path)

      expect(slack_notifier).to have_received(:post).with(
        hash_including({
          attachments: array_including(
            hash_including(
              {color: ExceptionNotifierConfig.color}
            )
          )
        })
      )
    end

    it "uses the header from ExceptionNotifierConfig as a main block" do
      error_notification.handled(message: message, user: user, path: path)

      expect(slack_notifier).to have_received(:post).with(
        hash_including({
          blocks: ExceptionNotifierConfig.blocks
        })
      )
    end

    it "posts the given _message_, _user_ and _path_ in an attachment " do
      error_notification.handled(message: message, user: user, path: path)

      expect(slack_notifier).to have_received(:post).with(
        hash_including({
          attachments: array_including(
            hash_including(
              {blocks: array_including(
                {
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
                }
              )}
            )
          )
        })
      )
    end
  end
end
