from conditions import GraderFirebreakViolated


FORBIDDEN_BEFORE_SCORING = {"target-item", "target-source-packet", "target-rendering", "target-paraphrase", "target-trap-class", "target-scorable-opportunities", "target-keyed-disposition", "target-derived-calibration"}


def validate_grader_firebreak(actors, artifacts, reads):
    primary_graders = {actor["actor_id"] for actor in actors if "primary-grader" in actor.get("role", [])}
    artifact_by_id = {artifact["artifact_id"]: artifact for artifact in artifacts}
    for read in reads:
        if read["reader"] not in primary_graders:
            continue
        artifact = artifact_by_id[read["artifact_id"]]
        kind = artifact.get("artifact_kind")
        if kind in FORBIDDEN_BEFORE_SCORING and read.get("purpose") != "locked-target-scoring":
            raise GraderFirebreakViolated(read["read_id"])
        if kind == "target-source-packet":
            if read.get("purpose") != "locked-target-scoring" or not read.get("response_lock_id") or read.get("item_id") != artifact.get("item_id"):
                raise GraderFirebreakViolated(read["read_id"])
    return True
