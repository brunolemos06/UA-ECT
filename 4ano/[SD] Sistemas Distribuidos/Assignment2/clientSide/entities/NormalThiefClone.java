package clientSide.entities;

/**
 * Normal Thief Clone
 * It specifies the normal thief methods for the clone
 */
public interface NormalThiefClone {

    /**
     * Set the thief id
     * @param id of the thief
     */
    public void setThiefId(int id);

    /**
     * Get the thief id
     * @return thief id
     */
    public int getThiefId();

    /**
     * Set the state of the normal thief
     * @param state of the thief
     */ 
    public void setThiefState(int state);
    /**
     * Get the state of the normal thief
     * @return normal thief state
     */
    public int getThiefState();

    /**
     * Set the thief agility
     * @param agility of the thief
     */
    public void setThiefAgility(int agility);

    /**
     * Get the thief agility
     * @return thief agility
     */
    public int getThiefAgility();
    
}
