package com.fraktalo.SCORM {

	/**
	 * @author filiperp
	 */
	public class SCORMLessonStatus {
/*		passed: Necessary number of objectives in the SCO were mastered, or the necessary score was achieved. Student is considered to have completed the SCO and passed.
completed: The SCO may or may note be passed, but all the elements in the SCO were experienced by the student. The student is considered to have completed the SCO. For instance, passing may depend on a certain score known to the LMS system. The SCO knows the raw score, but not whether that raw score was high enough to pass.
failed: The SCO was not passed. All the SCO elements may or may not have been completed by the student. The student is considered to have completed the SCO and failed.
incomplete: The SCO was begun but not finished.
browsed: The student launched the SCO with a LMS mode of "browse" on the initial attempt.
not attempted: Incomplete implies that the student made an attempt to perform the SCO, but for some reason was unable to finish it. Not attempted means that the student did not even begin the SCO. Maybe they just read the table of contents, or SCO abstract and decided they were not ready. Any algorithm within the SCO may be used to determine when the SCO moves from "not attempted" to "incomplete".
 * */

		public static const PASSED : String = "passed";
		public static const COMPLETED : String = "completed";
		public static const FAILED : String = "failed";
		public static const INCOMPLETE : String = "incomplete";
		public static const BROWSED : String = "browsed";
		public static const NOT_ATTEMPTED : String = "not attempted";
	}
}
