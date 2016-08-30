using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using MvcMusicStore.Models;

namespace MvcMusicStore.Controllers
{
    public class TemplatesController : Controller
    {
        //
        // GET: /Home/

        MusicStoreEntities storeDB = new MusicStoreEntities();

        public ActionResult Index()
        {
            // Get most popular albums
            var albums = GetTopSellingAlbums(5);

            return View(albums);
        }

        public ActionResult ArtistSearch(string q)
        {
            var artists = GetArtists(q);
            return Json(artists, JsonRequestBehavior.AllowGet);
        }

        public ActionResult QuickSearch(string term)
        {
            var artists = GetArtists(term).Select(a => new {value = a.Name});
            return Json(artists, JsonRequestBehavior.AllowGet);
        }

        private List<Artist> GetArtists(string searchString)
        {
            return storeDB.Artists
                .Where(a => a.Name.Contains(searchString))
                .ToList();
        }

        private List<Album> GetTopSellingAlbums(int count)
        {
            // Group the order details by album and return
            // the albums with the highest count

            return storeDB.Albums
                .OrderByDescending(a => a.OrderDetails.Count())
                .Take(count)
                .ToList();
        }
    }
}
