module Pre
  class CacheStore
    class Null
      def read key
      end
      def write key, val,options=nil
      end
      def fetch key
        yield
      end
    end
  end
end
