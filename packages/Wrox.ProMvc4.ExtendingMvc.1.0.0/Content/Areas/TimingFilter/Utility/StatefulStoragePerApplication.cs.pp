using System.Web;

namespace $rootnamespace$.Areas.TimingFilter.Utility
{
    public class StatefulStoragePerApplication : DictionaryStatefulStorage
    {
        // Ambient environment constructor
        public StatefulStoragePerApplication()
            : base(key => HttpContext.Current.Application[key], (key, value) => HttpContext.Current.Application[key] = value)
        {
        }

        // IoC-friendly constructor
        public StatefulStoragePerApplication(HttpApplicationStateBase app)
            : base(key => app[key], (key, value) => app[key] = value)
        {
        }
    }
}
