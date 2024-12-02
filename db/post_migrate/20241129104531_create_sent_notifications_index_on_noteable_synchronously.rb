# frozen_string_literal: true

class CreateSentNotificationsIndexOnNoteableSynchronously < Gitlab::Database::Migration[2.2]
  disable_ddl_transaction!
  milestone '17.7'

  INDEX_NAME = 'index_sent_notifications_on_noteable_type_noteable_id_and_id'
  COLUMN_NAMES = %i[noteable_id id]

  # Creating prepared index in 20241106125627_update_sent_notifications_index_on_noteable
  # https://gitlab.com/gitlab-org/gitlab/-/merge_requests/171687
  #
  # rubocop:disable Migration/PreventIndexCreation -- This index was created async previously, see above MR
  def up
    add_concurrent_index :sent_notifications, COLUMN_NAMES, where: "noteable_type = 'Issue'", name: INDEX_NAME
  end
  # rubocop:enable Migration/PreventIndexCreation

  def down
    remove_concurrent_index_by_name :sent_notifications, INDEX_NAME
  end
end
