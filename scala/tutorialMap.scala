import scala.collection.mutable._

object ScalaTutorial {

  def main(args: Array[String]) {

    val employees = Map("Manager" -> "Bob Smith",
      "Secretary" -> "Sue Brown")

    for ( (k,v) <- employees  )
      println("employe = " + v)
  }
}