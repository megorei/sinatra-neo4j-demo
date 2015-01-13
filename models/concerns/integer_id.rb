module IntegerId
  def self.included(base)
    base.class_eval do
      id_property :id, on: :generate_id

      def generate_id
        self.class.order(id: :desc).first.try(:id).to_i + 1
      end
    end
  end
end