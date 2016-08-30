using System.Web;

namespace $rootnamespace$.Areas.TimingFilter.Utility
{
    public class StatefulStoragePerSession : DictionaryStatefulStorage
    {
        // Ambient environment constructor
        public StatefulStoragePerSession()
            : base(key => HttpContext.Current.Session[key], (key, value) => HttpContext.Current.Session[key] = value)
        {
        }

        // IoC-friendly constructor
        public StatefulStoragePerSession(HttpSessionStateBase session)
            : base(key => session[key], (key, value) => session[key] = value)
        {
        }
    }
}
