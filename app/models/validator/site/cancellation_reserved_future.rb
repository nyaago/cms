module Validator
  
  module Site
  
    # = Validator::Site::CancellationReservedFuture
    # 解約予約が未来になっているかの検証
    class CancellationReservedFuture

      TRANSLATION_SCOPE = [:errors, :site,:messages]
    
      def validate(record)
        return if record.cancellation_reserved_at.nil?
        if record.cancellation_reserved_at < Time.now
          record.errors[:base] << I18n.t(:cancellation_reserved_future,
                                        :scope => TRANSLATION_SCOPE)
        end
      end  
    end

  end

end
