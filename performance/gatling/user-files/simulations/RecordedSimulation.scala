import scala.concurrent.duration._
import io.gatling.core.Predef._
import io.gatling.http.Predef._
import io.gatling.jdbc.Predef._
import scala.util.Random

class RecordedSimulation extends Simulation {

	val httpProtocol = http
		.baseURL("http://petstore.swagger.io")
		.inferHtmlResources()
		.acceptHeader("application/xml")
		.acceptEncodingHeader("gzip, deflate")
		.userAgentHeader("rest-client/2.0.2 (linux-gnu x86_64) ruby/2.4.1p111")

	val timestampFeeder = Iterator.continually(Map("timestamp" -> (100000000 + Random.nextInt(899999999)) ))

	val headers_1 = Map(
		"Accept" -> "*/*",
		"Content-Type" -> "application/json")

    val uri1 = "http://petstore.swagger.io/v2/pet"

	val scn = scenario("RecordedSimulation")
		.feed(timestampFeeder)
		.exec(http("request_0")
		.delete("/v2/pet/${timestamp}")
		.check(status.in(404,200)))
		.exec(http("request_1")
		.post("/v2/pet")
		.headers(headers_1)
		.body(ElFileBody("RecordedSimulation_0001_request.txt")).asJSON)
		.exec(http("request_2")
		.delete("/v2/pet/${timestamp}"))
		.exec(http("request_3")
		.get("/v2/pet/${timestamp}")
		.check(status.is(404)))
	
	setUp(scn.inject(rampUsers(4) over (2 seconds))).protocols(httpProtocol)
}