from app import db

class Response(db.Model):
	user_id = db.Column(db.String(20), primary_key=True)
	pretest_graph_type = db.Column(db.String(10), index=True)
	pretest_graph = db.Column(db.String(300))
	pretest_keys = db.Column(db.String(5000))
	pretest_reactions = db.Column(db.String(45000))

	def __repr__(self):
		return '<Response from {} {}>'.format(self.user_id, self.pretest_reactions)
