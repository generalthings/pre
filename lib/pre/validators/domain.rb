require 'resolv'

module Pre
  module Validators
    module Domain
      def self.expiry
        10080 # 7 days
      end

      def cache_key key
        "resolv_dns_result_#{key}"
      end

      def valid_domain?(resolution_provider = Resolv::DNS.new)
        value = cache_read cache_key(domain)
        if value.nil?
          begin
            value = resolution_provider.getresources(domain, Resolv::DNS::Resource::IN::MX).any?
            cache_write cache_key(domain), value
          rescue
            cache_write cache_key(domain), value, expires_in: expiry
            Rails.logger.error("Error resolving domain in MX Lookup for: #{domain}")
          end
        end

        value
      end
    end
  end
end
