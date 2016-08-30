using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using MvcMusicStore.Models;

namespace MvcMusicStore.Controllers
{
    public class AjaxFormController : Controller
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
