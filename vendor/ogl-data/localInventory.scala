import sys.process._
import java.io.File

if (args.length!=1) System.exit(0)

val base = new File(args(0))
val dir = new File(base,base.getName+".book")
val files = dir.listFiles.toList.map(_.getName).filter(_.endsWith(".html"))
val ids = files.map(_.replaceAll("p0{0,3}","").dropRight(5))
val ins = files.map(file => scala.io.Source.fromFile(new File(dir,file),"utf-8").getLines.toList.filter(_.trim.startsWith("<ins ")).map("""nlp .{4}""".r findFirstIn _).map("\""+_.get.drop(4)+"\""))
val lengths = ins.map(_.length)
val score = ins.map(l => if (l.length==0) "null" else (l.filter(m => m.contains("00")|m.contains("10")).length*1f/l.length).toString)

val wrt = new java.io.PrintWriter(new File(dir,"inventory.json"))

wrt.println(ids.zip(files).zip(ins).zip(lengths).zip(score).map{case ((((a,b),c),d),e) => List("\""+a+"\"","\""+b+"\"",c.mkString("[",",","]"),d,e)}.map(l => """{"id":"""+l(0)+""","file":"""+l(1)+""","raw":"""+l(2)+""","length":"""+l(3)+""","score":"""+l(4)+"""}""").mkString("[\n",",\n","\n]"))
wrt.flush; wrt.close
