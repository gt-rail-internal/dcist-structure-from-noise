"""users table created

Revision ID: f71c2bd60399
Revises: 
Create Date: 2020-02-11 00:22:22.453910

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'f71c2bd60399'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('response',
    sa.Column('user_id', sa.String(length=20), nullable=False),
    sa.Column('pretest_graph_type', sa.String(length=10), nullable=True),
    sa.Column('pretest_graph', sa.String(length=300), nullable=True),
    sa.Column('pretest_keys', sa.String(length=5000), nullable=True),
    sa.Column('pretest_reactions', sa.String(length=45000), nullable=True),
    sa.PrimaryKeyConstraint('user_id')
    )
    op.create_index(op.f('ix_response_pretest_graph_type'), 'response', ['pretest_graph_type'], unique=False)
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_index(op.f('ix_response_pretest_graph_type'), table_name='response')
    op.drop_table('response')
    # ### end Alembic commands ###
