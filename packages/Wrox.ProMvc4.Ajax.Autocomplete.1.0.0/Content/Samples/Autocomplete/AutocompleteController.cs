using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using MvcMusicStore.Models;

namespace MvcMusicStore.Controllers
{
    public class AutocompleteController : Controller
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
            return PartialView("_ArtistSearch", artists);
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

        public ActionResult DailyDeal()
        {
            var album = GetDailyDeal();
            return PartialView("_DailyDeal", album);
        }
        
        private Album GetDailyDeal()
        {
            return storeDB.Albums
                .OrderBy(a => a.Price)
                .First();
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
