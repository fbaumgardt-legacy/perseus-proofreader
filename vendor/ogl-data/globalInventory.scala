import scala.sys.process._
import java.io.{File,PrintWriter}

val oldIdRx = "\\d{4}-\\d{2}-\\d{2}-\\d{2}-\\d{2}_([^_]*)_.*".r
val newIdRx = "(.*)\\.\\d{4}-\\d{2}-\\d{2}-\\d{2}-\\d{2}".r

trait Meta {
  def id(dir:String):String = dir match {
    case oldIdRx(res) => {println(res);res}
    case newIdRx(res) => res
    case _ => dir
  }
  def url(id:String):String
  def name(id:String):String
  def path(id:String):String = id.replaceAll(".*/","")+"/"+id.replaceAll(".*/","")+".book"
  def hash(id:String):String = java.security.MessageDigest.getInstance("MD5").digest(path(id).getBytes).map("%02X".format(_)).mkString.toLowerCase.take(8)

  def toJSON(dir:String):String = "{ \"name\":\""+name(id(dir))+"\", \"path\":\""+path(dir)+"\", \"hash\":\""+hash(path(dir))+"\" }"
}

object Archive extends Meta {
  def url(id:String) = {
    println(id)
    val a = id.replaceAll(".*/","").replaceAll("\\..*","")
    "http://archive.org/1/items/"+a+"/"+a+"_meta.xml"
  }
  def name(id:String) =  {
    val xml = scala.xml.XML.load(url(id))
    def authors(x:scala.xml.Elem):String = (x \\ "creator").map(_.text.replaceAll(", \\d{4}-*\\d*","")).mkString(", ")
    def date(x:scala.xml.Elem):String = (x \\ "date").map(" ("+_.text+")").mkString+";"
    def title(x:scala.xml.Elem):String = " "+(x \\ "title").text+(x \\ "volume").map(" "+_.text).mkString
    authors(xml)+date(xml)+title(xml)
  }
}

object HEML extends Meta {
  def url(id:String) = "http://heml.mta.ca/lace/runs/"+id
  def name(id:String) = (scala.xml.XML.load(url(id)) \\ "h3" \ "a").text
}

object Hathi extends Meta {
  def url(id:String) = "http://babel.hathitrust.org/cgi/pt?id="+id
  def name(id:String) = (scala.xml.XML.load(url(id)) \ "head" \ "title").text.replaceAll(" - [\\w]+ View.*","")
}

if (args.length==2 && List("--archive","--heml","--hathi").contains(args(0))) {
  val factory:Meta = args(0) match {
    case "--archive" => Archive
    case "--heml" => HEML
    case "--hathi" => Hathi
    case _ => Archive
  }
  val wrt = new PrintWriter(args(1)+".json")
  wrt.println(factory.toJSON(args(1)))
  wrt.flush; wrt.close
  val inventory = new File("inventory")
  if ((inventory.exists && inventory.isDirectory) || inventory.mkdir) {
    val filename = inventory.listFiles.toList match {
      case Nil => "0000.json"
      case files:List[File] => {
        val jsonInDir = files.map(_.getName).filter(_.matches("\\d{4}\\.json"))
        val lastFile = jsonInDir.sorted.reverse.head
        "%04d".format(lastFile.take(4).toInt+1)+".json"
      }
    }
    "mv "+args(1)+".json inventory/"+filename!!

  } else println("Unable to create inventory files. Please check filenames and access rights.")
  
} else println("Usage: scala globalInventory.scala <--archive/--heml/--hathi> <repo-id>")

