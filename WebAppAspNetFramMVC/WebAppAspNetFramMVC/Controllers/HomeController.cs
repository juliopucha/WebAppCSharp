using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebAppAspNetFramMVC.Models;

namespace WebAppAspNetFramMVC.Controllers
{
    public class HomeController : Controller
    {
        // GET: Home
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult PaquetesEnviadosProvincia() 
        {
            MantenimientoPaquete mp = new MantenimientoPaquete();
            return View(mp.RecuperarTodos());
        }
    }
}