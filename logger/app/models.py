from app import db

class Response(db.Model):
    user_id = db.Column(db.String(20), primary_key=True)
    pretest_graph_type = db.Column(db.String(10), index=True, default = "")
    pretest_graph = db.Column(db.String(300), default = "")
    pretest_keys = db.Column(db.Text, default = "")
    pretest_reactions = db.Column(db.Text, default = "")
    pretest_status = db.Column(db.Integer, default = 1)
    pretest_key_status = db.Column(db.Text, default="")
    pretest_token = db.Column(db.String(12), default= "")

    def __repr__(self):
        return '<Response from {} {}>'.format(self.user_id, self.pretest_reactions)

